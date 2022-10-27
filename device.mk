## Copyright 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifneq ($(TARGET_BUILD_VARIANT),user)
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
endif

PRODUCT_PACKAGES += \
    WallpaperPicker \
    Launcher3 \
    libcrypto_vendor.vendor

#$_rbox_$_modify_$_zhengyang: add displayd
PRODUCT_PACKAGES += \
    displayd \
    libion
PRODUCT_PACKAGES += \
    RockchipPinnerService

PRODUCT_PACKAGES += \
    libmraa \
    libmraajava \
    libc++_shared

BOARD_SEPOLICY_DIRS += device/asus/tinker_board_2/sepolicy_vendor

#DMClient
PRODUCT_PACKAGES += \
    DMClient

#enable this for support f2fs with data partion
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

# used for fstab_generator, sdmmc controller address
PRODUCT_SDMMC_DEVICE := fe320000.dwmmc

# This ensures the needed build tools are available.
# TODO: make non-linux builds happy with external/f2fs-tool; system/extras/f2fs_utils
ifeq ($(HOST_OS),linux)
  TARGET_USERIMAGES_USE_F2FS := true
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.recovery.rk30board.rc:recovery/root/init.recovery.rk30board.rc \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/busybox:recovery/root/sbin/busybox \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.tinker_board_2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.tinker_board_2.rc \
    $(LOCAL_PATH)/init.rk3399.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.rk3399.rc \
    $(LOCAL_PATH)/init.rk3399.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.rk3399.usb.rc \
    $(LOCAL_PATH)/wake_lock_filter.xml:system/etc/wake_lock_filter.xml \
    $(LOCAL_PATH)/package_performance.xml:$(TARGET_COPY_OUT_ODM)/etc/package_performance.xml \
    $(LOCAL_PATH)/media_profiles_default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    $(LOCAL_PATH)/media_profiles_imx219.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_imx219.xml

# Touch
PRODUCT_COPY_FILES += \
    device/asus/tinker_board_2/touch/fts_ts.idc:system/usr/idc/fts_ts.idc
PRODUCT_COPY_FILES += \
    device/asus/tinker_board_2/touch/DIALOGUE_INC_PenMount_USB.idc:system/usr/idc/DIALOGUE_INC_PenMount_USB.idc

# led
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/led/led.sh:$(TARGET_COPY_OUT_VENDOR)/bin/led.sh

BOARD_SEPOLICY_DIRS += \
    device/asus/tinker_board_2/sepolicy/led

# 4g modem
ifeq ($(strip $(BOARD_HAS_4G_MODEM)), true)
PRODUCT_PACKAGES += \
    CarrierDefaultApp \
    CarrierConfig \
    rild \
    libril \
    libreference-ril \
    usb_dongle \
    usb_modeswitch

PRODUCT_PACKAGES += \
    android.hardware.radio@1.1-radio-service \
    android.hardware.radio.config@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
    ro.boot.noril=false \
    ro.radio.noril=false \
    ro.telephony.default_network=26 \
    ro.com.android.dataroaming=false

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/4g_modem/lib/libreference-ril.so:$(TARGET_COPY_OUT_VENDOR)/lib64/hw/libreference-ril.so \
    $(LOCAL_PATH)/4g_modem/rild.tinker_board_2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/rild.rc \
    $(LOCAL_PATH)/4g_modem/ppp/chat:/system/bin/chat \
    $(LOCAL_PATH)/4g_modem/ppp/ip-down:/system/etc/ppp/ip-down \
    $(LOCAL_PATH)/4g_modem/ppp/ip-up:/system/etc/ppp/ip-up

BOARD_SEPOLICY_DIRS += \
    device/asus/tinker_board_2/sepolicy/4g_modem

endif
#
## setup boot-shutdown animation configs.
#
HAVE_BOOT_ANIMATION := $(shell test -f $(TARGET_DEVICE_DIR)/bootanimation.zip && echo true)
HAVE_SHUTDOWN_ANIMATION := $(shell test -f $(TARGET_DEVICE_DIR)/shutdownanimation.zip && echo true)

ifeq ($(HAVE_BOOT_ANIMATION), true)
PRODUCT_COPY_FILES += $(TARGET_DEVICE_DIR)/bootanimation.zip:$(TARGET_COPY_OUT_ODM)/media/bootanimation.zip
endif

ifeq ($(HAVE_SHUTDOWN_ANIMATION), true)
PRODUCT_COPY_FILES += $(TARGET_DEVICE_DIR)/shutdownanimation.zip:$(TARGET_COPY_OUT_ODM)/media/shutdownanimation.zip
endif

#
## setup oem-content configs.
#
HAVE_PRESET_CONTENT := $(shell test -d $(TARGET_DEVICE_DIR)/pre_set && echo true)
HAVE_PRESET_DEL_CONTENT := $(shell test -d $(TARGET_DEVICE_DIR)/pre_set_del && echo true)

ifeq ($(HAVE_PRESET_DEL_CONTENT), true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(TARGET_DEVICE_DIR)/pre_set_del,$(TARGET_COPY_OUT_ODM)/pre_set_del)

PRODUCT_PROPERTY_OVERRIDES += ro.boot.copy_oem=true
endif

ifeq ($(HAVE_PRESET_CONTENT), true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(TARGET_DEVICE_DIR)/pre_set,$(TARGET_COPY_OUT_ODM)/pre_set)

PRODUCT_PROPERTY_OVERRIDES += ro.boot.copy_oem=true
endif

ifeq ($(strip $(BOARD_USE_ANDROIDNN)), true)
# ARMNN
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/armnn/android.hardware.neuralnetworks@1.1-service-armnn.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.neuralnetworks@1.1-service-armnn.rc \
    $(LOCAL_PATH)/armnn/android.hardware.neuralnetworks@1.1-service-armnn:$(TARGET_COPY_OUT_VENDOR)/bin/hw/android.hardware.neuralnetworks@1.1-service-armnn \
    $(LOCAL_PATH)/armnn/tuned_data:$(TARGET_COPY_OUT_VENDOR)/etc/armnn/tuned_data

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/armnn/bin,$(TARGET_COPY_OUT_VENDOR)/etc/armnn/bin)
endif

ifeq ($(BOARD_CAMERA_SUPPORT),true)
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml

PRODUCT_PACKAGES += \
    librkisp_aec \
    librkisp_awb \
    librkisp_af
endif

ifeq ($(BOARD_CAMERA_SUPPORT_EXT),true)
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml \
	frameworks/native/data/etc/android.hardware.camera.external.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.external.xml

PRODUCT_PACKAGES += \
     android.hardware.camera.provider@2.4-external-service
endif

ifeq ($(BUILD_WITH_GOOGLE_MARKET),false)
# copy xml files for Vulkan features.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_0_3.xml
endif

# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)


$(call inherit-product-if-exists, vendor/rockchip/rk3399/device-vendor.mk)

# Include thermal HAL module
BOARD_ROCKCHIP_THERMAL := true
$(call inherit-product, device/rockchip/common/modules/thermal.mk)

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/public.libraries.txt:vendor/etc/public.libraries.txt

#fireware for dp
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/dptx.bin:root/lib/firmware/rockchip/dptx.bin

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(LOCAL_PATH)/bluetooth

#add properties for spdif
PRODUCT_PROPERTY_OVERRIDES += persist.spdif_sounds = 0

#add properties for tcp adb
PRODUCT_PROPERTY_OVERRIDES += persist.adb.tcp.port = 5555

#
#add Rockchip properties here
#
PRODUCT_PROPERTY_OVERRIDES += \
                ro.ril.ecclist=112,911 \
                ro.opengles.version=196610 \
                wifi.interface=wlan0 \
                persist.tegra.nvmmlite = 1 \
                ro.audio.monitorOrientation=true \
                debug.nfc.fw_download=false \
                debug.nfc.se=false \
                ro.rk.screenoff_time=60000 \
                ro.rk.screenshot_enable=true \
                ro.rk.def_brightness=200 \
                ro.rk.homepage_base=http://www.google.com/webhp?client={CID}&amp;source=android-home \
                ro.rk.install_non_market_apps=false \
                vendor.hwc.compose_policy=6 \
                sys.wallpaper.rgb565=0 \
                sf.power.control=2073600 \
                sys.rkadb.root=0 \
                ro.sf.fakerotation=false \
                ro.sf.hwrotation=0 \
                ro.rk.MassStorage=false \
                ro.rk.systembar.voiceicon=true \
                ro.rk.systembar.tabletUI=false \
                ro.rk.LowBatteryBrightness=false \
                ro.tether.denied=false \
                sys.resolution.changed=false \
                ro.default.size=100 \
                ro.product.usbfactory=rockchip_usb \
                wifi.supplicant_scan_interval=15 \
                ro.factory.tool=0 \
                ro.kernel.android.checkjni=0 \
                ro.sf.lcd_density=240 \
                ro.build.shutdown_timeout=6 \
                persist.enable_task_snapshots=false \
                vendor.gralloc.no_afbc_for_fb_target_layer=1 \
                vendor.gralloc.no_afbc_for_sf_client_layer=1 \
                vendor.hwc.device.primary=HDMI-A \
                vendor.hwc.device.extend=DP \
                persist.sys.hdmi.cec_enable=true

PRODUCT_COPY_FILES += \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/e2fsck:recovery/root/sbin/e2fsck \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/resize2fs:recovery/root/sbin/resize2fs \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/parted:recovery/root/sbin/parted \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/sgdisk:recovery/root/sbin/sgdisk \

# Copy fstab
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab.rk30board.emmc:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.rk30board.emmc \
    $(LOCAL_PATH)/fstab.rk30board.ramdisk:$(TARGET_COPY_OUT_RAMDISK)/fstab.rk30board \
    $(LOCAL_PATH)/fstab.rk30board.sd:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.rk30board.sd \
    $(LOCAL_PATH)/recovery.fstab.emmc:recovery/root/system/etc/recovery.fstab.emmc \
    $(LOCAL_PATH)/recovery.fstab.sd:recovery/root/system/etc/recovery.fstab.sd \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.mount_all.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mount_all.rc

BOARD_SEPOLICY_DIRS += \
    device/asus/tinker_board_2/sepolicy/gpio \
    device/asus/tinker_board_2/sepolicy/dtoverlay \
    device/asus/tinker_board_2/sepolicy/media \
    device/asus/tinker_board_2/sepolicy/system \
    device/asus/tinker_board_2/sepolicy/vendor \
    device/asus/tinker_board_2/sepolicy/AsusDebugger

PRODUCT_PACKAGES += \
    TinkerIntegration \
    TinkerConfig

# AsusDebugger related packages
PRODUCT_PACKAGES += \
    asus-debugger-d \
    klogger \
    tcpdump2 \
    AsusDebugger \
    debugger.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/cpu_gpu_utility.sh:$(TARGET_COPY_OUT_VENDOR)/bin/cpu_gpu_utility.sh
