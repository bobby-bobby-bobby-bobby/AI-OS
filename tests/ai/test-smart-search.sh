#!/bin/sh
set -eu
ai/core/smart-search.sh "settings" | grep -q 'rank='
echo "smart-search: PASS"
