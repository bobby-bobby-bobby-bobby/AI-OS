#!/bin/sh
set -eu
mkdir -p tests/logs
./power/battery-status.sh > tests/logs/battery.log
./power/power-profile.sh performance > tests/logs/power-profile.log
./power/suspend-safe.sh >> tests/logs/power-profile.log
./power/brightness.sh set 50 >> tests/logs/power-profile.log
grep -q 'profile=performance' tests/logs/power-profile.log
echo "power-test: PASS"
