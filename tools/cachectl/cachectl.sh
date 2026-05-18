#!/bin/sh
set -eu
root="${AIOS_CACHE_ROOT:-/tmp/ai-os-cache}"
mkdir -p "$root" "$root/icons" "$root/wallpapers" "$root/fonts" "$root/thumbnails" "$root/app-launch"
cmd="${1:-status}"
case "$cmd" in
  warm)
    touch "$root/icons/index.cache" "$root/wallpapers/index.cache" "$root/fonts/index.cache" "$root/thumbnails/index.cache" "$root/app-launch/index.cache"
    echo "cache warmed" ;;
  clear)
    rm -rf "$root"/*
    mkdir -p "$root/icons" "$root/wallpapers" "$root/fonts" "$root/thumbnails" "$root/app-launch"
    echo "cache cleared" ;;
  status)
    find "$root" -maxdepth 2 -type f | sed 's#^#cache_file=#'
    ;;
  *) echo "usage: cachectl.sh {warm|clear|status}"; exit 1 ;;
esac
