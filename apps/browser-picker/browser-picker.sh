#!/bin/sh
set -eu
browser="${1:-firefox}"
case "$browser" in edge|chrome|firefox|opera|chromium|brave|vivaldi) ;; *) echo "unsupported"; exit 1;; esac
echo "$browser" > /tmp/ai-os-default-browser
echo "installing $browser (stub)"
echo "integrate sandbox wrapper + micro-vm wrapper (stub)"
