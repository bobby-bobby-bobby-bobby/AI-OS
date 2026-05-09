SHELL := /bin/sh
SCRIPTS := $(shell find packages vm -type f -name '*.sh')
all:
	@echo "compatibility tools are script-based"
check:
	@for s in $(SCRIPTS); do head -n1 $$s | grep -q '^#!/bin/sh' || { echo "bad shebang: $$s"; exit 1; }; done
install:
	@echo "install via build-rootfs.sh"
