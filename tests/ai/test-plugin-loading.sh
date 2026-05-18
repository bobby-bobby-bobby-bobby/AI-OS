#!/bin/sh
set -eu
ai/core/plugin-system.sh list | grep -q 'file-search.plugin'
ai/core/plugin-system.sh load file-search | grep -q '^name=file-search'
echo "plugin-loading: PASS"
