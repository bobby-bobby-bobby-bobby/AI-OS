#!/bin/sh
set -eu
[ -f /tmp/ai-os-default-browser ] || exec ./apps/browser-picker/browser-picker.sh firefox
