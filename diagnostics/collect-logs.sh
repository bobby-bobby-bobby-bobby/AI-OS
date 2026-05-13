#!/bin/sh
set -eu
mkdir -p tests/logs
out="tests/logs/diag-$(date +%Y%m%d-%H%M%S).tar.gz"
mkdir -p /tmp/ai-os-logs
cp -f ai-os/serial.log /tmp/ai-os-logs/ 2>/dev/null || true
cp -f ai-os/qemu-debug.log /tmp/ai-os-logs/ 2>/dev/null || true
cp -f /var/log/* /tmp/ai-os-logs/ 2>/dev/null || true
dmesg > /tmp/ai-os-logs/dmesg.log 2>/dev/null || true
cp -f config/*/* /tmp/ai-os-logs/ 2>/dev/null || true
tar -czf "$out" -C /tmp ai-os-logs
echo "$out"
