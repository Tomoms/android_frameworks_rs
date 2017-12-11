#
# Copyright (C) 2013 The Android Open Source Project
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

LOCAL_PATH := $(call my-dir)

# C/LLVM-IR source files for the library
clcore_base_files := \
    rs_allocation.c \
    rs_cl.c \
    rs_core.c \
    rs_element.c \
    rs_f16_math.c \
    rs_mesh.c \
    rs_matrix.c \
    rs_program.c \
    rs_sample.c \
    rs_sampler.c \
    rs_convert.c \
    rs_quaternion.c

clcore_cflags := -Iframeworks/rs/cpu_ref -DRS_DECLARE_EXPIRED_APIS

clcore_base_files_32 := \
    ll32/allocation.ll

clcore_base_files_64 := \
    ll64/allocation.ll

clcore_files := \
    $(clcore_base_files) \
    arch/generic.c

clcore_g_files := \
    rs_abi_debuginfo.c \
    arch/generic.c

clcore_files_32 := \
    $(clcore_base_files_32) \
    ll32/math.ll

clcore_files_64 := \
    $(clcore_base_files_64) \
    ll64/math.ll

clcore_neon_files := \
    $(clcore_base_files) \
    $(clcore_files_32) \
    arch/neon.ll \
    arch/clamp.c

clcore_arm64_files := \
    $(clcore_files_64) \
    arch/asimd.ll \
    arch/clamp.c

clcore_x86_files := \
    $(clcore_base_files) \
    arch/generic.c \
    arch/x86_sse2.ll \
    arch/x86_sse3.ll

# Grab the current value for $(RS_VERSION_DEFINE)
include frameworks/compile/slang/rs_version.mk

### Build new versions (librsrt_<ARCH>.bc) as host shared libraries.
### These will be used with bcc_compat and the support library.

# Build the ARM version of the library
include $(CLEAR_VARS)

# FIXME for 64-bit
LOCAL_32_BIT_ONLY := true

BCC_RS_TRIPLE := renderscript32-linux-androideabi
RS_TRIPLE_CFLAGS :=
LOCAL_MODULE := librsrt_arm.bc
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS += $(clcore_cflags)
LOCAL_SRC_FILES := $(clcore_files) $(clcore_files_32)
include $(LOCAL_PATH)/build_bc_lib.mk

# Build the MIPS version of the library
include $(CLEAR_VARS)

# FIXME for 64-bit
LOCAL_32_BIT_ONLY := true

BCC_RS_TRIPLE := renderscript32-linux-androideabi
RS_TRIPLE_CFLAGS :=
LOCAL_MODULE := librsrt_mips.bc
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS += $(clcore_cflags)
LOCAL_SRC_FILES := $(clcore_files) $(clcore_files_32)
include $(LOCAL_PATH)/build_bc_lib.mk

# Build the x86 version of the library
include $(CLEAR_VARS)

# FIXME for 64-bit
LOCAL_32_BIT_ONLY := true

BCC_RS_TRIPLE := renderscript32-linux-androideabi
RS_TRIPLE_CFLAGS := -D__i386__
LOCAL_MODULE := librsrt_x86.bc
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS += $(clcore_cflags) -DARCH_X86_HAVE_SSSE3
LOCAL_SRC_FILES := $(clcore_x86_files) $(clcore_base_files_32)
include $(LOCAL_PATH)/build_bc_lib.mk

include $(CLEAR_VARS)

BCC_RS_TRIPLE := renderscript64-linux-android
RS_TRIPLE_CFLAGS :=
LOCAL_MODULE := librsrt_arm64.bc
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS += $(clcore_cflags)
LOCAL_SRC_FILES := $(clcore_files) $(clcore_files_64)
include $(LOCAL_PATH)/build_bc_lib.mk

# Build the x86_64 version of the library
include $(CLEAR_VARS)

BCC_RS_TRIPLE := renderscript64-linux-android
RS_TRIPLE_CFLAGS := -D__x86_64__
LOCAL_MODULE := librsrt_x86_64.bc
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS += $(clcore_cflags) -DARCH_X86_HAVE_SSSE3
LOCAL_SRC_FILES := $(clcore_x86_files) $(clcore_base_files_64)
include $(LOCAL_PATH)/build_bc_lib.mk
