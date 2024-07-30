include device/asus/tinker_board_2/BoardConfig.mk

BOARD_SENSOR_ST := true
BOARD_SENSOR_COMPASS_AK8963-64 := true
BOARD_SENSOR_MPU_PAD := false
BOARD_COMPASS_SENSOR_SUPPORT := true
BOARD_GYROSCOPE_SENSOR_SUPPORT := true
CAMERA_SUPPORT_AUTOFOCUS:= false

BOARD_CAMERA_SUPPORT := true
BOARD_CAMERA_SUPPORT_EXT := true
PRODUCT_KERNEL_DTS := rk3399-tinker-board-2

# AB image definition
BOARD_USES_AB_IMAGE := false
BOARD_ROCKCHIP_VIRTUAL_AB_ENABLE := false
BOARD_HAS_RK_4G_MODEM := false

ifeq ($(strip $(BOARD_USES_AB_IMAGE)), true)
    include device/rockchip/common/BoardConfig_AB.mk
    TARGET_RECOVERY_FSTAB := device/asus/tinker_board_2/Tinker_Board_2/recovery.fstab_AB
endif

PRODUCT_FSTAB_TEMPLATE := device/asus/tinker_board_2/Tinker_Board_2/fstab.in
