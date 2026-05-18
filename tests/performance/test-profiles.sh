#!/bin/sh
set -eu
mkdir -p tests/logs
./services/perf-daemon.sh &
pid=$!
sleep 0.2
./tools/perfctl smooth > tests/logs/perf-profiles.log
./tools/perfctl status >> tests/logs/perf-profiles.log
grep -q 'profile=smooth' tests/logs/perf-profiles.log
echo stop > /tmp/perf-daemon.fifo
wait $pid || true
echo "perf-profiles-test: PASS"
