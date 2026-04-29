#!/bin/sh
set -eu
action="${1:-browse}"; src="${2:-.}"; dst="${3:-}"
case "$action" in
  browse) ls -la "$src" ;;
  copy) cp -r "$src" "$dst" ;;
  move) mv "$src" "$dst" ;;
  delete) rm -rf "$src" ;;
  preview) echo "preview stub: $src" ;;
  open-media) exec ./apps/media/media-viewer.sh "$src" ;;
  open-text) exec ./apps/editor/text-editor.sh open "$src" ;;
  *) echo "usage: file-manager.sh {browse|copy|move|delete|preview|open-media|open-text}" ;;
esac
