#!/bin/sh
set -eu
bash tests/ai/test-daemon-startup.sh
bash tests/ai/test-plugin-loading.sh
bash tests/ai/test-smart-search.sh
bash tests/ai/test-sidebar-integration.sh
