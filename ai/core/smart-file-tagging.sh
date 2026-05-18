#!/bin/sh
set -eu
f="${1:?file}"
case "$f" in
  *.sh) echo "tags:script,shell" ;;
  *.md|*.txt) echo "tags:document,text" ;;
  *.png|*.jpg|*.svg) echo "tags:image,asset" ;;
  *) echo "tags:general" ;;
esac
