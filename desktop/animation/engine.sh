#!/bin/sh
set -eu
action="${1:-transition}"
quality="${ANIM_QUALITY:-balanced}"
case "$action" in
  open|close|minimize|maximize|transition|physics) echo "animation=$action quality=$quality" ;;
  *) echo "usage: engine.sh {open|close|minimize|maximize|transition|physics}"; exit 1 ;;
esac
