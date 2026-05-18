#!/bin/sh
set -eu
echo "user=$(id -un)"
echo "host=$(uname -n)"
echo "arch=$(uname -m)"
echo "load=$(uptime | awk -F'load average: ' '{print $2}')"
echo "active_theme=${AIOS_THEME:-default}"
