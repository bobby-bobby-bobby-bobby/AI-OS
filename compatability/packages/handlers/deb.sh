#!/bin/sh
# UPCL — DEB package handler (Debian/Ubuntu/Kali format)

set -e

DEB_EXTRACT_DIR="/tmp/upcl-deb-$$"

deb_install() {
    local deb="$1"
    echo "DEB: Installing ${deb}..."

    mkdir -p "${DEB_EXTRACT_DIR}"
    trap 'rm -rf "${DEB_EXTRACT_DIR}"' EXIT

    # Try dpkg first (if available)
    if command -v dpkg >/dev/null 2>&1; then
        dpkg -i "${deb}"
        return
    fi

    # Manual extraction using ar and tar
    if ! command -v ar >/dev/null 2>&1; then
        echo "DEB: 'ar' not found. Install binutils." >&2
        exit 1
    fi

    cd "${DEB_EXTRACT_DIR}"
    ar x "$(realpath "${deb}")"

    # Extract control information
    if [ -f control.tar.gz ]; then
        tar xf control.tar.gz
    elif [ -f control.tar.xz ]; then
        tar xf control.tar.xz
    elif [ -f control.tar.zst ]; then
        tar xf control.tar.zst 2>/dev/null || \
            zstd -d control.tar.zst -o control.tar && tar xf control.tar
    fi

    # Read package info
    local pkg_name=""
    local pkg_version=""
    if [ -f control ]; then
        pkg_name="$(grep '^Package:' control | awk '{print $2}')"
        pkg_version="$(grep '^Version:' control | awk '{print $2}')"
    fi

    # Extract data to rootfs
    if [ -f data.tar.gz ]; then
        tar xf data.tar.gz -C /
    elif [ -f data.tar.xz ]; then
        tar xf data.tar.xz -C /
    elif [ -f data.tar.zst ]; then
        tar xf data.tar.zst -C / 2>/dev/null || \
            (zstd -d data.tar.zst -o data.tar && tar xf data.tar -C /)
    elif [ -f data.tar.bz2 ]; then
        tar xf data.tar.bz2 -C /
    fi

    # Run post-install scripts
    if [ -f postinst ] && [ -x postinst ]; then
        ./postinst configure
    fi

    # Record installation
    local db_dir="/var/lib/upcl/deb"
    mkdir -p "${db_dir}"
    echo "${pkg_name:-$(basename "${deb}" .deb)}:${pkg_version:-unknown}:deb" \
        >> "/var/lib/upcl/installed"

    echo "DEB: Installed ${pkg_name:-$(basename "${deb}" .deb)}"
}

deb_remove() {
    local name="$1"
    if command -v dpkg >/dev/null 2>&1; then
        dpkg -r "${name}"
    else
        echo "DEB: Manual removal not yet implemented." >&2
        exit 1
    fi
}

case "${1:-}" in
    install) deb_install "$2" ;;
    remove)  deb_remove "$2" ;;
    *)       echo "Usage: deb.sh install|remove <package>" >&2; exit 1 ;;
esac
