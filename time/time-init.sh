#!/bin/sh
set -eu
echo "UTC" > /etc/timezone
echo "0.0 0 0.0" > /etc/adjtime
./time/sysctl-time sync
