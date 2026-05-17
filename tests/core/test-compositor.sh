#!/bin/sh
set -eu
mkdir -p tests/logs
./compositor/compositor-engine.sh > tests/logs/core-compositor.log
grep -q 'shadows=on' tests/logs/core-compositor.log
grep -q 'virtual-desktops' tests/logs/core-compositor.log
echo "core-compositor-test: PASS"
