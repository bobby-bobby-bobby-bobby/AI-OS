#!/bin/sh
set -eu
echo "locale-gen stub for $(cat /etc/locale.conf 2>/dev/null || echo LANG=C)"
