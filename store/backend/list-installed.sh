#!/bin/sh
set -eu
cat /tmp/aios-installed-apps.db 2>/dev/null || echo "(none)"
