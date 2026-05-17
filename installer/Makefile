SHELL := /bin/sh
SCRIPTS := $(shell find . -maxdepth 1 -type f -name '*.sh')
all:
	@echo "installer scripts ready"
check:
	@for s in $(SCRIPTS); do head -n1 $$s | grep -q '^#!/bin/sh' || { echo "bad shebang: $$s"; exit 1; }; done
