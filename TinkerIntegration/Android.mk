###############################################################################
# Various GMS Sample Integration targets
LOCAL_PATH:= $(my-dir)

# TinkerIntegration
include $(CLEAR_VARS)
LOCAL_PACKAGE_NAME := TinkerIntegration
LOCAL_MODULE_OWNER := asus
LOCAL_MODULE_TAGS := optional
LOCAL_PRODUCT_MODULE := true
LOCAL_CERTIFICATE := platform
LOCAL_SRC_FILES := $(call all-java-files-under, src)
LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res_dhs_full $(LOCAL_PATH)/res
LOCAL_SDK_VERSION := current
include $(BUILD_PACKAGE)

# TinkerIntegrationGo
include $(CLEAR_VARS)
LOCAL_PACKAGE_NAME := TinkerIntegrationGo
LOCAL_MODULE_OWNER := asus
LOCAL_MODULE_TAGS := optional
LOCAL_PRODUCT_MODULE := true
LOCAL_CERTIFICATE := platform
LOCAL_SRC_FILES := $(call all-java-files-under, src)
LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res_dhs_go $(LOCAL_PATH)/res
LOCAL_SDK_VERSION := current
include $(BUILD_PACKAGE)

