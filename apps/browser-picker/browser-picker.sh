#!/bin/sh
set -eu
browser="${1:-firefox}"; mode="${2:-sandbox}"
case "$browser" in edge|chrome|firefox|opera|chromium|brave|vivaldi) ;; *) echo "unsupported"; exit 1;; esac
echo "$browser" > /tmp/ai-os-default-browser
echo "installing $browser (stub)"
echo "apply uBlock Origin defaults (stub)"
echo "apply DNS-level blocking defaults (stub)"
if [ "$mode" = "microvm" ]; then
  exec ./desktop/browser-select/wrappers/browser-microvm.sh "$browser"
else
  exec ./desktop/browser-select/wrappers/browser-sandbox.sh "$browser"
fi
