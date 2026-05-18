#!/bin/sh
set -eu
vendor=software
if [ -d /sys/class/drm ]; then
  info=$(ls /sys/class/drm 2>/dev/null | tr '\n' ' ')
  case "$info" in
    *nvidia*|*NVIDIA*) vendor=nvidia ;;
    *amdgpu*|*AMD*) vendor=amd ;;
    *i915*|*Intel*) vendor=intel ;;
    *mali*|*Mali*) vendor=mali ;;
    *powervr*|*PowerVR*) vendor=powervr ;;
    *) vendor=generic-gpu ;;
  esac
fi
echo "$vendor"
