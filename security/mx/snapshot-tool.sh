#!/bin/sh
set -eu
root="${AIOS_INSTALL_ROOT:-/tmp/aios-install-root}"
mkdir -p "$root/.snapshots"
name="${1:-snap-$(date +%s)}"
mkdir -p "$root/.snapshots/$name"
cp -a "$root/etc" "$root/.snapshots/$name/" 2>/dev/null || true
echo "snapshot:$name"
