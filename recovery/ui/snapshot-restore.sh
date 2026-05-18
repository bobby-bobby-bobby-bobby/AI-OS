#!/bin/sh
set -eu
root="${AIOS_INSTALL_ROOT:-/tmp/aios-install-root}"
mode="${1:-latest}"
snapdir="$root/.snapshots"
if [ "$mode" = "latest" ]; then mode=$(ls -1 "$snapdir" 2>/dev/null | tail -n1); fi
[ -n "$mode" ] && [ -d "$snapdir/$mode" ] || { echo "snapshot not found"; exit 1; }
cp -a "$snapdir/$mode/." "$root/"
echo "restored:$mode"
