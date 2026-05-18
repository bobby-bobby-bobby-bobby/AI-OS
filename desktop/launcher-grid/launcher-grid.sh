#!/bin/sh
set -eu
layout="${AIOS_LAUNCHER_LAYOUT:-6x4}"
echo "launcher-grid layout=$layout"
awk 'NF>0{print " - "$0}' apps/app-registry.txt
