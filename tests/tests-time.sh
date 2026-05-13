#!/bin/sh
set -eu
mkdir -p tests/logs
./time/time-init.sh
./time/sysctl-time sync
test -f /etc/timezone && test -f /etc/adjtime && test -f /tmp/ntp-sync.log
./time/sysctl-time status > tests/logs/time-status.log
echo "time-test: PASS"
