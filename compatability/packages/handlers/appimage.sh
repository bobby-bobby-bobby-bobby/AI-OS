#!/bin/sh
# UPCL — AppImage handler

set -e

APPIMAGE_DIR="/opt/appimages"
DESKTOP_DIR="/usr/share/applications"
BIN_DIR="/usr/local/bin"

appimage_install() {
    local appimage="$1"
    local name
    name="$(basename "${appimage}" .AppImage | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

    echo "AppImage: Installing ${name}..."
    mkdir -p "${APPIMAGE_DIR}"

    local dest="${APPIMAGE_DIR}/${name}.AppImage"
    cp "${appimage}" "${dest}"
    chmod +x "${dest}"

    # Extract desktop entry and icon if possible
    if "${dest}" --appimage-extract-and-run --version >/dev/null 2>&1 || true; then
        local squashfs_dir="/tmp/appimage-${name}-$$"
        "${dest}" --appimage-extract 2>/dev/null && \
            mv squashfs-root "${squashfs_dir}" 2>/dev/null || true

        # Copy .desktop file
        for f in "${squashfs_dir}"/*.desktop 2>/dev/null; do
            [ -f "$f" ] || continue
            # Update Exec path
            sed "s|Exec=.*|Exec=${dest}|g" "$f" > "${DESKTOP_DIR}/${name}.desktop"
        done

        # Copy icon
        for f in "${squashfs_dir}"/*.png "${squashfs_dir}"/*.svg 2>/dev/null; do
            [ -f "$f" ] || continue
            cp "$f" "/usr/share/pixmaps/${name}.$(basename "$f" | sed 's/.*\.//')"
            break
        done

        rm -rf "${squashfs_dir}"
    fi

    # Create wrapper script
    cat > "${BIN_DIR}/${name}" <<WRAPPER
#!/bin/sh
exec "${dest}" "\$@"
WRAPPER
    chmod +x "${BIN_DIR}/${name}"

    echo "AppImage: ${name}" >> /var/lib/upcl/installed
    echo "AppImage: Installed ${name} → ${dest}"
    echo "  Run with: ${name}"
}

appimage_remove() {
    local name="$1"
    rm -f "${APPIMAGE_DIR}/${name}.AppImage"
    rm -f "${BIN_DIR}/${name}"
    rm -f "${DESKTOP_DIR}/${name}.desktop"
    sed -i "/^AppImage: ${name}/d" /var/lib/upcl/installed 2>/dev/null || true
    echo "AppImage: Removed ${name}"
}

appimage_run() {
    local appimage="$1"
    shift
    chmod +x "${appimage}"
    exec "${appimage}" "$@"
}

case "${1:-}" in
    install) appimage_install "$2" ;;
    remove)  appimage_remove "$2" ;;
    run)     appimage_run "$2" "$@" ;;
    *)       echo "Usage: appimage.sh install|remove|run <appimage>" >&2; exit 1 ;;
esac
