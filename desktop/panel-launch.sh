#!/bin/sh
set -eu
app="${1:-files}"
case "$app" in
  media) exec ./apps/media/media-viewer.sh ./README.md ;;
  editor) exec ./apps/editor/text-editor.sh open ./README.md ;;
  files) exec ./apps/files/file-manager.sh browse . ;;
  browser-picker) exec ./apps/browser-picker/browser-picker.sh firefox sandbox ;;
  ui-picker) exec ./apps/ui-picker/ui-picker.sh ;;
  settings) exec ./apps/settings/settings-app.sh system ;;
  *) echo "unknown app"; exit 1 ;;
esac
