#!/bin/sh
set -eu
action="${1:?}"
shift || true
case "$action" in
  summarize|suggest|autofill|search|voice|ocr|translate) ai/core/assistant-daemon-client.sh "$action" "$*" ;;
  *) echo "unsupported"; exit 1 ;;
esac
