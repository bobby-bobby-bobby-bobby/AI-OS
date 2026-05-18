#!/bin/sh
set -eu
sock="${AIOS_AI_FIFO:-/tmp/ai-assistant.fifo}"
[ -p "$sock" ] || mkfifo "$sock"
mkdir -p /var/log
log=/var/log/ai-assistant.log
: > "$log"
echo "assistant:start" >> "$log"
while read -r line < "$sock"; do
  cmd=$(printf '%s' "$line" | cut -d' ' -f1)
  rest=$(printf '%s' "$line" | cut -d' ' -f2-)
  case "$cmd" in
    summarize) echo "summary:${rest%%.*}." ;;
    suggest) echo "suggestion:consider ${rest%% *}" ;;
    autofill) echo "autofill:${rest}..." ;;
    search) ai/core/smart-search.sh "$rest" ;;
    voice) echo "voice:stub" ;;
    ocr) echo "ocr:stub" ;;
    translate) echo "translate:stub" ;;
    stop) echo "assistant:stop" >> "$log"; break ;;
    *) echo "unknown" ;;
  esac >> /tmp/ai-assistant.resp
  echo "assistant:req $cmd" >> "$log"
done
