#!/bin/sh
set -e

mkdir -p toolchain
cd toolchain

# musl libc
if [ ! -d musl-1.2.5 ]; then
  curl -LO https://musl.libc.org/releases/musl-1.2.5.tar.gz
  tar xf musl-1.2.5.tar.gz
fi

# TinyCC (tcc)
if [ ! -d tcc ]; then
  git clone https://repo.or.cz/tinycc.git tcc
fi

# LLVM/Clang (optional, heavy; AI can decide how to use it)
if [ ! -d llvm-project ]; then
  git clone --depth=1 https://github.com/llvm/llvm-project.git
fi

# BusyBox (optional fallback utilities)
if [ ! -d busybox ]; then
  git clone --depth=1 https://git.busybox.net/busybox
fi
