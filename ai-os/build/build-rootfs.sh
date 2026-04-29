#!/bin/sh
set -e

ROOTFS=rootfs
TOOLCHAIN=toolchain

echo "[*] Creating root filesystem structure..."

mkdir -p $ROOTFS/{bin,sbin,usr/bin,usr/sbin,usr/lib,lib,etc,proc,sys,dev,tmp,var,home,boot}

# Basic device nodes (AI will expand)
sudo mknod -m 622 $ROOTFS/dev/console c 5 1 || true
sudo mknod -m 666 $ROOTFS/dev/null c 1 3 || true

echo "[*] Installing musl libc..."
if [ -d $TOOLCHAIN/musl-1.2.5 ]; then
  cd $TOOLCHAIN/musl-1.2.5
  ./configure --prefix=/usr
  make
  make DESTDIR=../../$ROOTFS install
  cd ../..
fi

echo "[*] Installing BusyBox (fallback utilities)..."
if [ -d $TOOLCHAIN/busybox ]; then
  cd $TOOLCHAIN/busybox
  make defconfig
  make
  make CONFIG_PREFIX=../../$ROOTFS install
  cd ../..
fi

echo "[*] Root filesystem prepared. AI will populate userland, init, pkgmgr, etc."
