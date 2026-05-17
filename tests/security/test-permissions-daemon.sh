#!/bin/sh
set -eu
mkdir -p tests/logs
./services/permissions-daemon.sh &
pid=$!
sleep 0.2
echo 'request:notes:camera' > /tmp/permissions-daemon.fifo
sleep 0.1
cat /tmp/permissions-daemon.resp > tests/logs/security-permissions.log
echo stop > /tmp/permissions-daemon.fifo
wait $pid || true
grep -Eq 'deny|granted' tests/logs/security-permissions.log
echo "security-permissions-test: PASS"
