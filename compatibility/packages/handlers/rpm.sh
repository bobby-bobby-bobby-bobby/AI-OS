#!/usr/bin/env bash
set -euo pipefail
op=${1:?}; pkg=${2:?}; root=${3:-/}
case "$op" in
  install)
    command -v rpm2cpio >/dev/null || { echo "rpm2cpio required" >&2; exit 1; }
    tmp=$(mktemp -d)
    (cd "$tmp" && rpm2cpio "$pkg" | cpio -idmv)
    cp -a "$tmp"/. "$root"/
    rm -rf "$tmp"
    ;;
  *) exit 1;;
esac
