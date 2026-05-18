#!/bin/sh
set -eu
mkdir -p tests/logs
./security/sandbox/sandboxctl set demo "camera=deny,mic=allow,filesystem=read,network=deny"
./security/sandbox/sandboxctl get demo > tests/logs/security-sandbox.log
grep -q 'demo:' tests/logs/security-sandbox.log
echo "security-sandbox-test: PASS"
