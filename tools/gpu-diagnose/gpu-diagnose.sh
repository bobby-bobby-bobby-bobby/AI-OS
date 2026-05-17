#!/bin/sh
set -eu
vendor=$(./graphics/gpu/gpu-detect.sh)
status=$(./graphics/gpu/gpu-api.sh status)
features="compositing,animations,rendering"
hints="install mesa/vulkan/opencl stack; vendor-specific driver as needed"
echo "detected_gpu=$vendor"
echo "features=$features"
echo "acceleration_status=$status"
echo "driver_hints=$hints"
