#!/bin/sh
set -eu
ui="${1:-rounded}"; glass="${2:-off}"; theme="${3:-dark}"; icons="${4:-default}"; wallpaper="${5:-wallpaper01.png}"
printf 'ui=%s\nglass=%s\ntheme=%s\nicons=%s\nwallpaper=%s\n' "$ui" "$glass" "$theme" "$icons" "$wallpaper" > /tmp/ai-os-ui.conf
echo "live preview stub updated"
