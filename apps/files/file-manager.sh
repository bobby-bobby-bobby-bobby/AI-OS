#!/bin/sh
set -eu
action="${1:-browse}"; src="${2:-.}"; dst="${3:-}"
ext="${src##*.}"
case "$action" in
  browse) ls -la "$src" ;;
  copy) cp -r "$src" "$dst" ;;
  move) mv "$src" "$dst" ;;
  delete) rm -rf "$src" ;;
  preview|thumbnail) exec ./apps/media/media-viewer.sh "$src" ;;
  open-media) exec ./apps/media/media-viewer.sh "$src" ;;
  open-text|open-with-editor) exec ./apps/editor/text-editor.sh open "$src" ;;
  open-default)
    case "$ext" in png|jpg|jpeg|gif|webp|mp3|wav|ogg|mp4|mkv|webm|pdf) exec ./apps/media/media-viewer.sh "$src";; *) exec ./apps/editor/text-editor.sh open "$src";; esac ;;
  run) exec ./langmgr/run.sh "$src" ;;
  open-in-vm) exec ./compatibility/vm/suspicious-vm.sh "$src" ;;
  *) echo "usage: file-manager.sh {browse|copy|move|delete|preview|thumbnail|open-media|open-text|open-with-editor|open-default|run|open-in-vm}" ;;
esac
