#!/bin/sh
set -eu
cmd="${1:-help}"
case "$cmd" in
  install|remove|update|search|list) echo "aipkg: $cmd (stub)" ;;
  *) echo "usage: aipkg.sh {install|remove|update|search|list}" ;;
esac
