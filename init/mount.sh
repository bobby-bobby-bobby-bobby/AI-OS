#!/bin/sh
set -eu
mount -t proc proc /proc || true
mount -t sysfs sys /sys || true
mount -t devtmpfs devtmpfs /dev || true
mount -t tmpfs tmpfs /tmp || true
