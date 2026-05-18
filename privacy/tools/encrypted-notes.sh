#!/bin/sh
set -eu
file="${1:-/tmp/secure.note}"; text="${2:-}"
key="${AIOS_NOTES_KEY:-aios}"
if [ -n "$text" ]; then printf '%s' "$text" | openssl enc -aes-256-cbc -pbkdf2 -pass pass:"$key" -out "$file" 2>/dev/null; echo "saved:$file"; else openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$key" -in "$file" 2>/dev/null; fi
