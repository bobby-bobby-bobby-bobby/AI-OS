#!/bin/sh
set -e

# Fetch the latest Linux kernel (shallow clone to keep repo small)
mkdir -p kernel
if [ ! -d kernel/linux ]; then
  git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git kernel/linux
else
  echo "Kernel source already present, updating..."
  cd kernel/linux
  git fetch --depth=1 origin
  git reset --hard origin/master
fi
