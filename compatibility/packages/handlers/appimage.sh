#!/usr/bin/env bash
set -euo pipefail
op=${1:?}; app=${2:?}; root=${3:-/}
apps_dir="$root/opt/appimages"
mkdir -p "$apps_dir"
case "$op" in
  install)
    base=$(basename "$app")
    cp "$app" "$apps_dir/$base"
    chmod +x "$apps_dir/$base"
    ;;
  *) exit 1;;
esac
