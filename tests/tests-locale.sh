#!/bin/sh
set -eu
mkdir -p tests/logs
./locale/syslocale set en_US.UTF-8
./locale/locale-gen.sh > tests/logs/locale-gen.log
./input/set-keyboard-layout.sh us
grep -q 'LANG=en_US.UTF-8' /etc/locale.conf
grep -q 'XKBLAYOUT=us' /etc/vconsole.conf
echo "locale-test: PASS"
