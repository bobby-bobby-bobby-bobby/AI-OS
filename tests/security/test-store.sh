#!/bin/sh
set -eu
mkdir -p tests/logs
./apps/store/store-ui.sh available > tests/logs/security-store.log
./apps/store/store-ui.sh install calculator >> tests/logs/security-store.log
./apps/store/store-ui.sh installed >> tests/logs/security-store.log
grep -q 'calculator' tests/logs/security-store.log
echo "security-store-test: PASS"
