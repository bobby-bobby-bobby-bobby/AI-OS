#!/usr/bin/env bash
set -euo pipefail
root_mnt=${1:?root}
report=/tmp/ai-os-installer/gpu-vendor
mkdir -p "$root_mnt/etc/ai-os"
vendor=intel
[[ -f "$report" ]] && vendor=$(cat "$report")
cat > "$root_mnt/etc/ai-os/drivers.conf" <<EOF2
GPU_VENDOR=$vendor
INSTALL_NVIDIA_OPEN=1
INSTALL_MESA=1
ENABLE_FWUPD=1
EOF2
echo "driver policy set for $vendor"
