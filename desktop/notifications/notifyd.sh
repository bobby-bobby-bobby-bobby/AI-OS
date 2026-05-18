#!/bin/sh
set -eu
urgency="${AIOS_NOTIFY_URGENCY:-normal}"
echo "[notify][$urgency] ${*:-notification}"
