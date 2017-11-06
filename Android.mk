LOCAL_PATH:= $(call my-dir)

ANDROID_MAJOR :=
ANDROID_MINOR :=
ANDROID_MICRO :=

ifndef ANDROID_MAJOR
include build/core/version_defaults.mk
ifeq ($(strip $(PLATFORM_VERSION)),)
$error(*** Cannot get Android platform version)
endif
ANDROID_MAJOR = $(shell echo $(PLATFORM_VERSION) | cut -d . -f 1)
ANDROID_MINOR = $(shell echo $(PLATFORM_VERSION) | cut -d . -f 2)
ANDROID_MICRO = $(shell echo $(PLATFORM_VERSION) | cut -d . -f 3)
endif

ifeq ($(strip $(ANDROID_MAJOR)),)
$(error *** ANDROID_MAJOR undefined)
endif

ifeq ($(strip $(ANDROID_MINOR)),)
$(error *** ANDROID_MINOR undefined)
endif

ifeq ($(strip $(ANDROID_MICRO)),)
$(warning *** ANDROID_MICRO undefined. Assuming 0)
ANDROID_MICRO = 0
endif

ifeq ($(strip $(BOARD_USE_MOTO_SF)), true)
USE_MOTO_SF = 1
else
USE_MOTO_SF = 0
endif

include $(CLEAR_VARS)
LOCAL_SRC_FILES := droidmedia.cpp \
                   droidmediacamera.cpp \
                   droidmediaconstants.cpp \
                   droidmediacodec.cpp \
                   droidmediaconvert.cpp \
                   droidmediarecorder.cpp \
                   allocator.cpp \
                   droidmediabuffer.cpp \
                   private.cpp

LOCAL_SHARED_LIBRARIES := libc \
                          libdl \
                          libutils \
                          libcutils \
                          libcamera_client \
                          libgui \
                          libui \
                          libbinder \
                          libstagefright \
                          libstagefright_foundation \
                          libmedia
LOCAL_CPPFLAGS=-DANDROID_MAJOR=$(ANDROID_MAJOR) -DANDROID_MINOR=$(ANDROID_MINOR) -DANDROID_MICRO=$(ANDROID_MICRO)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libdroidmedia
ifeq ($(strip $(BOARD_QTI_CAMERA_32BIT_ONLY)), true)
LOCAL_MODULE_TARGET_ARCH := arm
endif

ifeq ($(strip $(ANDROID_MAJOR)),7)
LOCAL_C_INCLUDES := frameworks/native/include/media/openmax \
                    frameworks/native/include/media/hardware
else
LOCAL_C_INCLUDES := frameworks/native/include/media/openmax
endif

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := minimedia.cpp
LOCAL_C_INCLUDES := frameworks/av/services/camera/libcameraservice \
                    frameworks/av/media/libmediaplayerservice \
                    system/media/camera/include
LOCAL_SHARED_LIBRARIES := libcameraservice \
                          libmediaplayerservice \
                          libcamera_client \
                          libutils \
                          libbinder \
                          libgui \
                          libcutils \
                          libui
LOCAL_MODULE_TAGS := optional
LOCAL_CPPFLAGS=-DANDROID_MAJOR=$(ANDROID_MAJOR) -DANDROID_MINOR=$(ANDROID_MINOR) -DANDROID_MICRO=$(ANDROID_MICRO)
LOCAL_MODULE := minimediaservice
ifeq ($(strip $(BOARD_QTI_CAMERA_32BIT_ONLY)), true)
LOCAL_MODULE_TARGET_ARCH := arm
endif
include $(BUILD_EXECUTABLE)

###############################################################
# build minisfservice executable
include $(CLEAR_VARS)
LOCAL_CLANG := true

LOCAL_C_INCLUDES := frameworks/native/services/surfaceflinger

LOCAL_SRC_FILES := minisf.cpp allocator.cpp
LOCAL_SHARED_LIBRARIES := libutils \
                          libbinder \
                          libmedia \
                          libgui \
                          libcutils \
                          libui
ifeq ($(strip $(BOARD_USE_MOTO_SF)), true)
LOCAL_SHARED_LIBRARIES += libsurfaceflinger
endif

LOCAL_MODULE_TAGS := optional
LOCAL_CPPFLAGS := -DANDROID_MAJOR=$(ANDROID_MAJOR) -DANDROID_MINOR=$(ANDROID_MINOR) -DANDROID_MICRO=$(ANDROID_MICRO)
ifeq ($(strip $(BOARD_USE_MOTO_SF)), true)
LOCAL_CPPFLAGS += -DUSE_MOTO_SF
endif
ifneq ($(CM_BUILD),)
LOCAL_CPPFLAGS += -DCM_BUILD
endif
LOCAL_MODULE := minisfservice
ifeq ($(strip $(BOARD_QTI_CAMERA_32BIT_ONLY)), true)
LOCAL_MODULE_TARGET_ARCH := arm
endif
include $(BUILD_EXECUTABLE)
