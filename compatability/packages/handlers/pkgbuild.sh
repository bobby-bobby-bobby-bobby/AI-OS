#!/bin/sh
# UPCL — PKGBUILD handler (Arch Linux)

set -e

pkgbuild_install() {
    local pkg="$1"

    if command -v pacman >/dev/null 2>&1; then
        pacman -U "${pkg}"
        return
    fi

    # Manual extraction of .pkg.tar.zst
    echo "PKGBUILD: Extracting ${pkg}..."
    tar xf "${pkg}" -C / --exclude='.PKGINFO' --exclude='.BUILDINFO' \
        --exclude='.MTREE' --exclude='.INSTALL' 2>/dev/null || \
    tar xf "${pkg}" -C /

    local pkg_name
    pkg_name="$(basename "${pkg}" .pkg.tar.zst | sed 's/-x86_64//' | sed 's/-any//')"
    echo "${pkg_name}:unknown:pkgbuild" >> "/var/lib/upcl/installed"
    echo "PKGBUILD: Installed ${pkg_name}"
}

pkgbuild_build() {
    local dir="$1"
    if [ ! -f "${dir}/PKGBUILD" ]; then
        echo "PKGBUILD: No PKGBUILD found in ${dir}" >&2
        exit 1
    fi
    if command -v makepkg >/dev/null 2>&1; then
        cd "${dir}" && makepkg -si
    else
        echo "PKGBUILD: makepkg not available" >&2
        exit 1
    fi
}

case "${1:-}" in
    install) pkgbuild_install "$2" ;;
    build)   pkgbuild_build "$2" ;;
    *)       echo "Usage: pkgbuild.sh install|build <package>" >&2; exit 1 ;;
esac
