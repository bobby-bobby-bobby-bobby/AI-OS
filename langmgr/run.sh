#!/bin/sh
set -eu
file="${1:?file}"
ext="${file##*.}"
case "$ext" in
  bf) exec ./langmgr/stubs/brainfuck.sh "$file" ;;
  bas) echo "run BASIC in DOSBox stub: $file" ;;
  exe) echo "run Windows binary via Wine/VM stub: $file" ;;
  *) echo "generic run stub for $file" ;;
esac
