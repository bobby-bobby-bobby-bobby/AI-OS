#!/bin/sh
set -eu
mkdir -p tests/logs
export AIOS_INSTALL_ROOT=/tmp/aios-install-root
./installer/userctl a11y-defaults SCREEN_READER=on HIGH_CONTRAST=on
./pkgmgr/aipkg.sh upgrade >/dev/null
./recovery/recover-rootfs.sh > tests/logs/a11y-persist.log
test -f /tmp/aios-install-root/etc/accessibility-defaults.conf
grep -q 'SCREEN_READER=on' /tmp/aios-install-root/etc/accessibility-defaults.conf
echo "a11y-persist-test: PASS"
