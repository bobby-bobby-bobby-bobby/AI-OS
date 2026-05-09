all:
	@echo "icon placeholders ready"
check:
	@test -f index.yaml
	@count=$$(ls *.svg 2>/dev/null | wc -l); [ $$count -ge 20 ]
