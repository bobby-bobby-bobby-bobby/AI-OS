#!/bin/sh
set -eu
echo "ufw default deny incoming"
echo "ufw default allow outgoing"
echo "ufw enable"
