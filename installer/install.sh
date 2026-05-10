#!/bin/sh
set -eu
./installer/auto-partition.sh
./installer/auto-format.sh
./installer/populate-rootfs.sh
./installer/bootloader-setup.sh
./installer/firstboot-wizard.sh
echo "install pipeline complete (stub)"
