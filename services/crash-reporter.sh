#!/bin/sh
set -eu
mkdir -p /var/log/aios-crash
in="${1:-}"
[ -n "$in" ] || in="unknown crash"
echo "$(date -u +%FT%TZ) $in" >> /var/log/aios-crash/reports.log
echo recorded
