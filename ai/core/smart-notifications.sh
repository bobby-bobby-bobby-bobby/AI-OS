#!/bin/sh
set -eu
in="${*:-no notifications}"
echo "summary:${in}" | cut -c1-120
