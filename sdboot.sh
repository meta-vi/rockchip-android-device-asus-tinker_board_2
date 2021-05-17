#!/bin/bash -e
if [ ! $TARGET_PRODUCT ]; then
    TARGET_PRODUCT=WW_Tinker_Board_2
fi

BASEDIR="$(dirname $(readlink -f $0))"
OUT="$BASEDIR/../../../rockdev/Image-$TARGET_PRODUCT"
SIMG2IMG=$BASEDIR/../../../out/host/linux-x86/bin/simg2img
GPT_IMG=${OUT}/$TARGET_PRODUCT-raw.img
PARAMETER_FILE=${OUT}/parameter.txt
SPARSE_IMG="super"
LOADER1_START=64

declare -a PARTITION_NAME_LIST
declare -a PARTITION_NAME_LENGTH

PARTITION_NAME_LIST[0]="idbloader"
PARTITION_NAME_LENGTH[0]=$((0x4000))

IMAGE_LENGTH=$((0x4000))

function get_partition(){
    num=1
    parameter=`cat ${PARAMETER_FILE} | grep '^CMDLINE:mtdparts' | sed 's/ //g' | sed 's/.*:\(0x.*[^)])\).*/\1/' | sed 's/,/ /g'`
    for partition in ${parameter};do
        partition_name=`echo ${partition} | sed 's/\(.*\)(\(.*\))/\2/'`
        partition_name=${partition_name%%:*}
        #echo "${partition_name}"
        #start_partition=`echo ${partition} | sed 's/.*@\(.*\)(.*)/\1/'`
        length_partition=`echo ${partition} | sed 's/\(.*\)@.*/\1/'`
        if [ "${length_partition}" = "-" ]; then
                length_partition=0
        fi

        PARTITION_NAME_LIST[${num}]=${partition_name}
        PARTITION_NAME_LENGTH[${num}]=$((length_partition))
        IMAGE_LENGTH=$(($IMAGE_LENGTH + $length_partition))
        num=$(($num + 1))
    done
}

get_partition
# gpt back up
IMAGE_LENGTH=$(($IMAGE_LENGTH + 35))
# keep space 2M
IMAGE_LENGTH=$(($IMAGE_LENGTH + 2 * 2 * 1024))
echo "IMAGE_LENGTH:${IMAGE_LENGTH}"

for sparse in $SPARSE_IMG;do
#    if (file ${OUT}/$sparse.img | grep -q "Android sparse image");then
        echo "simg2img $sparse.img"
        mv ${OUT}/$sparse.img ${OUT}/$sparse.simg.img
        $SIMG2IMG ${OUT}/$sparse.simg.img ${OUT}/$sparse.img
#    fi
done

dd if=/dev/zero of=${GPT_IMG} bs=512 count=0 seek=${IMAGE_LENGTH} status=none
parted -s ${GPT_IMG} mklabel gpt

IMAGE_SEEK=0
IMAGE_NOT_FOUND="dtb security backup cache metadata frp userdata splash"

for((i=0;i<${#PARTITION_NAME_LIST[*]};i++))
do
    partition_name=${PARTITION_NAME_LIST[$i]}
    partition_start=${IMAGE_SEEK}
    partition_end=$((${partition_start} + ${PARTITION_NAME_LENGTH[$i]} - 1))
    if [ "$i" == "0" ];then
            partition_start=${LOADER1_START}
    fi
#    printf "%-15s %-15s %-15s %-15fMB\n" ${partition_name}   ${partition_start}    ${partition_end} $(echo "scale=4;${PARTITION_NAME_LENGTH[$i]} / 2048" | bc)

    if [ "$i" == "$((${#PARTITION_NAME_LIST[*]} -1))" ];then
        parted -s ${GPT_IMG} -- unit s mkpart ${partition_name} ${partition_start}  -34s
    else
        if [ "${partition_name}" == "idbloader" ];then
            :
	else
            parted -s ${GPT_IMG} unit s mkpart ${partition_name} ${partition_start} ${partition_end}
        fi
    fi

    if [ -f "${OUT}/${partition_name}.img" ];then
        dd if=${OUT}/${partition_name}.img of=${GPT_IMG} conv=notrunc seek=${partition_start} status=none
    else
        if [[ "${IMAGE_NOT_FOUND}" =~ "${partition_name}" ]]; then
            :
        else
            echo "not found ${partition_name} img"
            exit -1
        fi
    fi
    IMAGE_SEEK=$(($IMAGE_SEEK + ${PARTITION_NAME_LENGTH[$i]}))
done

for sparse in $SPARSE_IMG;do
#    if (file ${OUT}/$sparse.simg.img | grep -q "Android sparse image");then
            mv ${OUT}/$sparse.simg.img ${OUT}/$sparse.img
#    fi
done

