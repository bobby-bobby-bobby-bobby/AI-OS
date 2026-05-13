#!/bin/sh
set -eu
mkdir -p tests/logs
export AIOS_ROOT=/tmp/aios-install-root
./pkgmgr/aipkg.sh update > tests/logs/upgrade.log
./pkgmgr/aipkg.sh upgrade >> tests/logs/upgrade.log
test -f /tmp/aios-install-root/var/lib/aipkg/last-snapshot
./pkgmgr/aipkg.sh status >> tests/logs/upgrade.log
echo "upgrade-test: PASS"
