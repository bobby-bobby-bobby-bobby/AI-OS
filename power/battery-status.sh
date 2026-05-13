#!/bin/sh
set -eu
base="/sys/class/power_supply"; [ -d "$base" ] && ls "$base" || echo "no-battery"
