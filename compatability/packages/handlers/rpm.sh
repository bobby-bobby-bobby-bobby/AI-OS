#!/bin/sh
# UPCL — RPM package handler (Fedora/openSUSE/RHEL)

set -e

RPM_EXTRACT_DIR="/tmp/upcl-rpm-$$"

rpm_install() {
    local rpm="$1"
    echo "RPM: Installing ${rpm}..."

    # Try rpm2cpio + cpio for extraction
    if ! command -v rpm2cpio >/dev/null 2>&1 && ! command -v rpm >/dev/null 2>&1; then
        echo "RPM: neither 'rpm' nor 'rpm2cpio' found" >&2
        # Try to install via alien if available
        if command -v alien >/dev/null 2>&1; then
            echo "RPM: converting via alien..."
            alien --to-tgz "${rpm}" -o /tmp/rpm-converted.tgz
            tar xf /tmp/rpm-converted.tgz -C /
            return
        fi
        exit 1
    fi

    mkdir -p "${RPM_EXTRACT_DIR}"
    trap 'rm -rf "${RPM_EXTRACT_DIR}"' EXIT

    if command -v rpm >/dev/null 2>&1; then
        rpm -ivh --nodeps "${rpm}"
    else
        cd "${RPM_EXTRACT_DIR}"
        rpm2cpio "$(realpath "${rpm}")" | cpio -idmv
        cp -a . /
    fi

    local pkg_name
    pkg_name="$(basename "${rpm}" .rpm | sed 's/-[0-9].*//')"
    echo "${pkg_name}:unknown:rpm" >> "/var/lib/upcl/installed"
    echo "RPM: Installed ${pkg_name}"
}

rpm_remove() {
    local name="$1"
    if command -v rpm >/dev/null 2>&1; then
        rpm -e "${name}"
    else
        echo "RPM: manual removal not yet implemented" >&2
        exit 1
    fi
}

case "${1:-}" in
    install) rpm_install "$2" ;;
    remove)  rpm_remove "$2" ;;
    *)       echo "Usage: rpm.sh install|remove <package>" >&2; exit 1 ;;
esac
