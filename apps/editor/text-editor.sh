#!/bin/sh
set -eu
cmd="${1:-open}"; file="${2:-untitled.txt}"
case "$cmd" in
  open) echo "open tab: $file" ;;
  save) echo "save file as typed: $file" ;;
  search) echo "search stub in $file" ;;
  replace) echo "replace stub in $file" ;;
  *) echo "usage: text-editor.sh {open|save|search|replace} [file]" ;;
esac
echo "features: tabs, search/replace, syntax-highlighting(stub), local-only"
