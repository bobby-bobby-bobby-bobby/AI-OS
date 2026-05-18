#!/bin/sh
set -eu
mkdir -p tests/logs
./hardware-driver-manager.sh > tests/logs/hardware-hooks.log
grep -q 'Hardware Detection' tests/logs/hardware-hooks.log
echo "hardware-hooks-test: PASS"
