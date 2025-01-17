#!/bin/bash -eu
# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

set -eu
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export TORCHAO_LIBRARIES=${SCRIPT_DIR}/../../../../../..
export CMAKE_OUT=/tmp/cmake-out/torch_ao/tests

IS_ARM64=0
hash arch; retval=$?
if [[ ${retval} -eq 0 && $(arch) == "arm64" ]]; then
    IS_ARM64=1
fi

cmake -DCMAKE_BUILD_TYPE=Debug \
    -DTORCHAO_LIBRARIES=${TORCHAO_LIBRARIES} \
    -DTORCHAO_BUILD_KLEIDIAI=${IS_ARM64} \
    -S ${TORCHAO_LIBRARIES}/torchao/experimental/kernels/cpu/aarch64/tests \
    -B ${CMAKE_OUT}

cmake --build ${CMAKE_OUT}

# Run
${CMAKE_OUT}/test_quantization
${CMAKE_OUT}/test_reduction
${CMAKE_OUT}/test_bitpacking
${CMAKE_OUT}/test_linear
${CMAKE_OUT}/test_valpacking
${CMAKE_OUT}/test_embedding
