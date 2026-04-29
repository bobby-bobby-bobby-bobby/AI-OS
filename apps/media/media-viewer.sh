#!/bin/sh
set -eu
file="${1:-}"
[ -n "$file" ] || { echo "usage: media-viewer.sh <file>"; exit 1; }
case "${file##*.}" in
  png|jpg|jpeg|gif|webp) mode=image ;;
  mp3|wav|ogg) mode=audio ;;
  mp4|mkv|webm) mode=video ;;
  pdf) mode=pdf ;;
  txt|md|json|xml|c|h|py|js) mode=document ;;
  *) mode=unknown ;;
esac
echo "AI-OS Media Viewer [$mode] (rounded-ui, optional glass effect): $file"
