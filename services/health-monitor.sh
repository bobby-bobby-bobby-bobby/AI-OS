#!/bin/sh
set -eu
out=/var/log/aios-health.log
load=$(uptime | awk -F'load average: ' '{print $2}')
mem=$(free -m | awk '/Mem:/ {print $3"/"$2"MB"}')
disk=$(df -h / | awk 'NR==2 {print $5}')
echo "$(date -u +%FT%TZ) load=$load mem=$mem disk=$disk" >> "$out"
