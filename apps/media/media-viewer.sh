#!/bin/sh
set -eu
file="${1:-}"; captions="${2:-off}"
[ -n "$file" ] || { echo "usage: media-viewer.sh <file> [captions:on|off]"; exit 1; }
case "${file##*.}" in
  png|jpg|jpeg|gif|webp) mode=image ;;
  mp3|wav|ogg) mode=audio ;;
  mp4|mkv|webm) mode=video ;;
  pdf) mode=pdf ;;
  txt|md|json|xml|c|h|py|js) mode=document ;;
  *) mode=unknown ;;
esac
echo "media-viewer mode=$mode file=$file captions=$captions"
