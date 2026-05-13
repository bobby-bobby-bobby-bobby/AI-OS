#!/bin/sh
set -eu
root="${AIOS_INSTALL_ROOT:-/tmp/aios-install-root}"
latest="$(ls -1 "$root/.snapshots" 2>/dev/null | tail -n1)"
[ -n "$latest" ] || { echo "no snapshots"; exit 1; }
echo "recovering rootfs from $latest"
[ -f "$root/etc/firstboot.conf" ] && grep -E 'A11Y_' "$root/etc/firstboot.conf" || true
