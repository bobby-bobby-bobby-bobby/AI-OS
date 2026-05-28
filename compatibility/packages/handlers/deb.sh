#!/usr/bin/env bash
set -euo pipefail
op=${1:?}; pkg=${2:?}; root=${3:-/}
case "$op" in
  install)
    command -v dpkg-deb >/dev/null || { echo "dpkg-deb required" >&2; exit 1; }
    tmp=$(mktemp -d)
    dpkg-deb -x "$pkg" "$tmp"
    cp -a "$tmp"/. "$root"/
    rm -rf "$tmp"
    ;;
  *) exit 1;;
esac
