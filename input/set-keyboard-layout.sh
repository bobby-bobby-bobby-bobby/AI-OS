#!/bin/sh
set -eu
echo "XKBLAYOUT=${1:-us}" > /etc/vconsole.conf
