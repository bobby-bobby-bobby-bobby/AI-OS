#!/bin/sh
set -eu
root=/tmp/aios-install-root
mkdir -p "$root/.snapshots/s2" "$root/.snapshots/s2/etc"
echo ok > "$root/.snapshots/s2/etc/restore-marker"
AIOS_INSTALL_ROOT=$root security/opensuse/btrfs-rollback.sh s2
test -f "$root/etc/restore-marker"
echo "rollback-integration: PASS"
