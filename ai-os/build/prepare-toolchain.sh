#!/bin/sh
mkdir -p toolchain
cd toolchain

# Fetch musl
curl -LO https://musl.libc.org/releases/musl-1.2.5.tar.gz
tar xf musl-1.2.5.tar.gz

# Fetch TinyCC
git clone https://repo.or.cz/tinycc.git tcc
