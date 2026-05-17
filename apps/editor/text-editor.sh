#!/bin/sh
set -eu
cmd="${1:-open}"; file="${2:-untitled.txt}"
registry="config/associations/syntax-registry.yaml"
case "$cmd" in
  open) echo "open tab: $file" ;;
  save) echo "save file as typed: $file" ;;
  search) echo "search stub in $file" ;;
  replace) echo "replace stub in $file" ;;
  open-with) echo "open with editor: $file" ;;
  *) echo "usage: text-editor.sh {open|save|search|replace|open-with} [file]" ;;
esac
echo "syntax registry: $registry"
echo "features: tabs, search/replace, syntax-highlighting(stub), local-only"
