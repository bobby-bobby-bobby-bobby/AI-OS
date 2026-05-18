#!/bin/sh
set -eu
cmd="${1:-menu}"
case "$cmd" in
  check) services/update-daemon.sh check ;;
  changelog) services/update-daemon.sh changelog "${2:-}" ;;
  schedule) services/update-daemon.sh schedule "${2:-weekly Sun 03:00}" ;;
  rollback) services/update-daemon.sh rollback ;;
  channel) services/update-daemon.sh channel set "${2:-stable}" ;;
  menu) echo "update-ui: check|changelog|schedule|rollback|channel" ;;
  *) exit 1 ;;
esac
