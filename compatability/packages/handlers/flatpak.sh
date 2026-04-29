#!/bin/sh
# UPCL — Flatpak handler

set -e

flatpak_install() {
    local app_id="$1"
    echo "Flatpak: Installing ${app_id}..."

    if ! command -v flatpak >/dev/null 2>&1; then
        echo "Flatpak: flatpak not installed" >&2
        echo "  Run: aipkg install flatpak" >&2
        exit 1
    fi

    # Add Flathub if not already present
    flatpak remote-add --if-not-exists flathub \
        https://dl.flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

    flatpak install -y flathub "${app_id}"
    echo "Flatpak: Installed ${app_id}"
}

flatpak_remove() {
    local app_id="$1"
    flatpak uninstall -y "${app_id}"
}

flatpak_run() {
    local app_id="$1"
    shift
    flatpak run "${app_id}" "$@"
}

case "${1:-}" in
    install) flatpak_install "$2" ;;
    remove)  flatpak_remove "$2" ;;
    run)     flatpak_run "$2" "$@" ;;
    *)       echo "Usage: flatpak.sh install|remove|run <app-id>" >&2; exit 1 ;;
esac
