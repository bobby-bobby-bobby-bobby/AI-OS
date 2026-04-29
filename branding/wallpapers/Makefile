all:
	@echo "wallpaper placeholders ready"
check:
	@test -f index.json
	@count=$$(ls wallpaper*.png 2>/dev/null | wc -l); [ "$$count" = "25" ]
