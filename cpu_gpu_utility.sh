#! /vendor/bin/sh

LOG_TAG="cpu_gpu_utility.sh"
CONFIG_FILE="/dtoverlay/config.txt"

logi () {
    /vendor/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

CPU_GOVERNOR=`cat $CONFIG_FILE | grep cpu_governor | awk 'BEGIN {FS="="}; {print $2}'`
GPU_GOVERNOR=`cat $CONFIG_FILE | grep gpu_governor | awk 'BEGIN {FS="="}; {print $2}'`
A53_MIN_FREQ=`cat $CONFIG_FILE | grep a53_minfreq | awk 'BEGIN {FS="="}; {print $2}'`
A53_MAX_FREQ=`cat $CONFIG_FILE | grep a53_maxfreq | awk 'BEGIN {FS="="}; {print $2}'`
A72_MIN_FREQ=`cat $CONFIG_FILE | grep a72_minfreq | awk 'BEGIN {FS="="}; {print $2}'`
A72_MAX_FREQ=`cat $CONFIG_FILE | grep a72_maxfreq | awk 'BEGIN {FS="="}; {print $2}'`

logi "CPU_GOVERNOR=$CPU_GOVERNOR, GPU_GOVERNOR=$GPU_GOVERNOR, A53_MIN_FREQ=$A53_MIN_FREQ, A53_MAX_FREQ=$A53_MAX_FREQ, A72_MIN_FREQ=$A72_MIN_FREQ, A72_MAX_FREQ=$A72_MAX_FREQ"

for governor in $(ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
do
  echo "$CPU_GOVERNOR" > $governor
  sleep 0.05
done
echo "$GPU_GOVERNOR" > /sys/class/devfreq/ff9a0000.gpu/governor

echo "$A53_MIN_FREQ" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
sleep 0.05
echo "$A53_MAX_FREQ" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
sleep 0.05
echo "$A72_MIN_FREQ" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
sleep 0.05
echo "$A72_MAX_FREQ" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
