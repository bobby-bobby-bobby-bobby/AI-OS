#!/bin/sh
set -eu
echo "reset network stack"
ip link set lo up 2>/dev/null || true
echo "nameserver 1.1.1.1" > /tmp/recovery-resolv.conf
echo "net-repair:ok"
