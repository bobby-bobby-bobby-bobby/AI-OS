#!/bin/sh
set -e

mkdir -p external
cd external

# QEMU
if [ ! -d qemu ]; then
  git clone --depth=1 https://gitlab.com/qemu-project/qemu.git
fi

# Waydroid (Android container)
if [ ! -d waydroid ]; then
  git clone --depth=1 https://github.com/waydroid/waydroid.git
fi

# microG (Play Services replacement)
if [ ! -d microg ]; then
  git clone --depth=1 https://github.com/microg/GmsCore.git microg
fi

# Wine
if [ ! -d wine ]; then
  git clone --depth=1 https://gitlab.winehq.org/wine/wine.git
fi

# DOSBox
if [ ! -d dosbox ]; then
  git clone --depth=1 https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk dosbox
fi

# Flatpak
if [ ! -d flatpak ]; then
  git clone --depth=1 https://github.com/flatpak/flatpak.git
fi

# Firejail
if [ ! -d firejail ]; then
  git clone --depth=1 https://github.com/netblue30/firejail.git
fi

# AppArmor (profiles/tools; actual kernel support via config)
if [ ! -d apparmor ]; then
  git clone --depth=1 https://gitlab.com/apparmor/apparmor.git
fi

# Btrfs-progs
if [ ! -d btrfs-progs ]; then
  git clone --depth=1 https://github.com/kdave/btrfs-progs.git
fi
