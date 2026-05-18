#!/bin/sh
set -eu
mkdir -p tests/logs
printf test | ./coreutils/sha256sum > tests/logs/core-binaries.log
./coreutils/uuidgen >> tests/logs/core-binaries.log || true
./coreutils/aiservicectl status all >> tests/logs/core-binaries.log
grep -q 'aiservicectl status all' tests/logs/core-binaries.log
echo "core-binaries-test: PASS"
