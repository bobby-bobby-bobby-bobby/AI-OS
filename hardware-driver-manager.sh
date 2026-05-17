#!/bin/sh
set -eu
echo "== Hardware Detection =="
[ -d /sys/class/drm ] && ls /sys/class/drm | sed 's/^/DRM: /' || true
[ -d /sys/class/net ] && ls /sys/class/net | sed 's/^/NET: /' || true
[ -d /sys/class/bluetooth ] && ls /sys/class/bluetooth | sed 's/^/BT: /' || echo "BT: none"
if [ -d /sys/class/drm ]; then
  echo "Recommend: install nvidia-driver or mesa stack based on PCI IDs"
  echo "Recommend: dkms-rebuild stub on kernel update"
fi
arch=$(uname -m)
if [ "$arch" = "aarch64" ]; then
  echo "ARM SoC check: list DTB/firmware requirements (stub)"
fi
