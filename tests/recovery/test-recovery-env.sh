#!/bin/sh
set -eu
root=/tmp/aios-install-root
mkdir -p "$root/.snapshots/s1" "$root/etc"
echo ok > "$root/.snapshots/s1/marker"
AIOS_INSTALL_ROOT="$root" recovery/ui/snapshot-restore.sh s1
test -f "$root/marker"
recovery/bin/net-repair.sh >/tmp/recovery-net.log
grep -q net-repair:ok /tmp/recovery-net.log
echo "recovery-env: PASS"
