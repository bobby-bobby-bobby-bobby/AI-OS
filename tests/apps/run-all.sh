#!/bin/sh
set -eu
bash tests/apps/test-app-launches.sh
bash tests/apps/test-app-launcher-registry.sh
bash tests/apps/test-app-theme-locale-a11y.sh
