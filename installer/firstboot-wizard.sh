#!/bin/sh
set -eu
echo "first boot wizard: browser + ui picker + user setup (stub)"
./apps/browser-picker/browser-picker.sh firefox sandbox || true
./apps/ui-picker/ui-picker.sh rounded off dark default wallpaper01.png || true
