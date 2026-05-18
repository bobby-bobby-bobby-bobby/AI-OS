#!/bin/sh
set -eu
p="${1:-balanced}"; echo "$p" > /tmp/power-profile; echo "profile=$p"
