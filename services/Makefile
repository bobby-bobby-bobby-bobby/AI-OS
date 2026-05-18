DAEMONS := session-manager compositor notification-daemon settings-daemon sound-daemon input-daemon display-daemon wallpaper-daemon icon-theme-daemon cursor-theme-daemon sound-theme-daemon update-daemon power-daemon network-daemon bluetooth-daemon media-indexer search-daemon clipboard-daemon hotkey-daemon autostart-daemon
.PHONY: all check
all:
	@echo "services stubs ready"
check:
	@for d in $(DAEMONS); do [ -x $$d.sh ] || exit 1; done
