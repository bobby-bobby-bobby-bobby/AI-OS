SHELL := /bin/sh
SCRIPTS := $(shell find . -type f -name '*.sh')
all:
	@echo "security integration is script/config based"
check:
	@for s in $(SCRIPTS); do head -n1 $$s | grep -q '^#!/bin/sh' || { echo "bad shebang: $$s"; exit 1; }; done
