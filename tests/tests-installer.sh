#!/bin/sh
set -eu
mkdir -p tests/logs
export AIOS_INSTALL_ROOT=/tmp/aios-install-root
export INSTALL_USER=tester INSTALL_PASS=secret INSTALL_LOCALE=en_US.UTF-8 INSTALL_TZ=UTC INSTALL_KBD=us
export FIRSTBOOT_USER=tester FIRSTBOOT_TZ=UTC FIRSTBOOT_LOCALE=en_US.UTF-8 FIRSTBOOT_KBD=us FIRSTBOOT_SR=on FIRSTBOOT_HC=on
./installer/install.sh > tests/logs/installer.log
test -f /tmp/aios-install-root/etc/locale.conf
test -f /tmp/aios-install-root/etc/timezone
test -f /tmp/aios-install-root/var/lib/initial-snapshot
grep -q 'LANG=en_US.UTF-8' /tmp/aios-install-root/etc/locale.conf
echo "installer-test: PASS"
