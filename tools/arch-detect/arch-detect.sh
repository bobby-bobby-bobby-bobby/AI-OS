#!/bin/sh
set -eu
host=$(uname -m)
case "$host" in
  aarch64|arm64) arch=arm64; prebuilt_kernel=yes; native_qemu=no; optimize="skip-heavy-build" ;;
  armv7l) arch=armhf; prebuilt_kernel=yes; native_qemu=no; optimize="skip-heavy-build" ;;
  x86_64) arch=x86_64; prebuilt_kernel=no; native_qemu=yes; optimize="full-build" ;;
  *) arch=unknown; prebuilt_kernel=no; native_qemu=yes; optimize="safe-mode" ;;
esac
echo "arch=$arch prebuilt_kernel=$prebuilt_kernel qemu_on_demand=$native_qemu optimize=$optimize"
