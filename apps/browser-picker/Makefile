.PHONY: all check install
all:
	@echo "script app"
check:
	@for s in *.sh; do [ -f $$s ] && head -n1 $$s | grep -q '^#!/bin/sh'; done
install:
	@echo "installed via ai-os/build/build-rootfs.sh"
