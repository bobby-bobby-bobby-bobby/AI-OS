#!/bin/sh
set -eu
mkdir -p tests/logs
./network/netmgr.sh dhcp
./network/netmgr.sh ntp
./network/netmgr.sh status > tests/logs/network.log
test -f /tmp/dhcp.log
test -f /tmp/ntp-sync.log
echo "network-test: PASS"
