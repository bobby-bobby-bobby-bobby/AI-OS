#!/bin/sh
set -eu
mkdir -p tests/logs
./apps/vm-manager/vm-manager.sh create devvm > tests/logs/vm.log
./apps/vm-manager/vm-manager.sh list >> tests/logs/vm.log
./apps/vm-manager/vm-manager.sh config devvm 4 4096 >> tests/logs/vm.log
./apps/vm-manager/vm-manager.sh delete devvm >> tests/logs/vm.log
grep -q 'created devvm' tests/logs/vm.log
grep -q 'deleted devvm' tests/logs/vm.log
echo "vm-lifecycle-test: PASS"
