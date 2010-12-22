LOCAL_PATH:= $(call my-dir)

#
# Build the software OpenGL ES library
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	egl.cpp                     \
	state.cpp		            \
	texture.cpp		            \
    Tokenizer.cpp               \
    TokenManager.cpp            \
    TextureObjectManager.cpp    \
    BufferObjectManager.cpp     \
	array.cpp.arm		        \
	fp.cpp.arm		            \
	light.cpp.arm		        \
	matrix.cpp.arm		        \
	mipmap.cpp.arm		        \
	primitives.cpp.arm	        \
	vertex.cpp.arm

LOCAL_CFLAGS += -DLOG_TAG=\"libagl\"
LOCAL_CFLAGS += -DGL_GLEXT_PROTOTYPES -DEGL_EGLEXT_PROTOTYPES
LOCAL_CFLAGS += -fvisibility=hidden

LOCAL_SHARED_LIBRARIES := libcutils libhardware libutils liblog libpixelflinger libETC1 libui
LOCAL_LDLIBS := -lpthread -ldl

ifeq ($(TARGET_ARCH),arm)
	LOCAL_SRC_FILES += fixed_asm.S iterators.S
	LOCAL_CFLAGS += -fstrict-aliasing
endif

ifeq ($(TARGET_ARCH),mips)
    LOCAL_SRC_FILES += arch-$(TARGET_ARCH)/fixed_asm.S
    LOCAL_CFLAGS += -fstrict-aliasing
    # The graphics code can generate division by zero
    LOCAL_CFLAGS += -mno-check-zero-division
endif

ifneq ($(TARGET_LIBAGL_USE_GRALLOC_COPYBITS),)
    LOCAL_CFLAGS += -DLIBAGL_USE_GRALLOC_COPYBITS
    LOCAL_SRC_FILES += copybit.cpp
    LOCAL_SHARED_LIBRARIES += libui
endif

# we need to access the private Bionic header <bionic_tls.h>
LOCAL_C_INCLUDES += bionic/libc/private
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/include/qcom

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/egl
LOCAL_MODULE:= libGLES_android

include $(BUILD_SHARED_LIBRARY)
