#!/bin/sh
# aipkg — Package database functions

DB_DIR="${AIPKG_DB:-/var/lib/aipkg}"
INSTALLED_DB="${DB_DIR}/installed"

db_init() {
    mkdir -p "${INSTALLED_DB}"
}

db_is_installed() {
    local pkg="$1"
    [ -f "${INSTALLED_DB}/${pkg}/PKGINFO" ]
}

db_install_record() {
    local pkg="$1"
    local version="$2"
    local desc="$3"
    mkdir -p "${INSTALLED_DB}/${pkg}"
    cat > "${INSTALLED_DB}/${pkg}/PKGINFO" <<EOF
Name=${pkg}
Version=${version}
Description=${desc}
InstalledAt=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF
}

db_remove_record() {
    local pkg="$1"
    rm -rf "${INSTALLED_DB}/${pkg}"
}

db_get_version() {
    local pkg="$1"
    if [ -f "${INSTALLED_DB}/${pkg}/PKGINFO" ]; then
        grep '^Version=' "${INSTALLED_DB}/${pkg}/PKGINFO" | cut -d= -f2
    fi
}

db_list_installed() {
    if [ ! -d "${INSTALLED_DB}" ] || [ -z "$(ls -A "${INSTALLED_DB}" 2>/dev/null)" ]; then
        echo "No packages installed."
        return 0
    fi
    printf "%-30s %s\n" "PACKAGE" "VERSION"
    printf "%-30s %s\n" "-------" "-------"
    for pkg_dir in "${INSTALLED_DB}"/*/; do
        [ -f "${pkg_dir}/PKGINFO" ] || continue
        local pkg
        pkg="$(basename "${pkg_dir}")"
        local ver
        ver="$(grep '^Version=' "${pkg_dir}/PKGINFO" | cut -d= -f2)"
        printf "%-30s %s\n" "${pkg}" "${ver}"
    done
}

db_save_files() {
    local pkg="$1"
    shift
    mkdir -p "${INSTALLED_DB}/${pkg}"
    printf '%s\n' "$@" > "${INSTALLED_DB}/${pkg}/files"
}

db_get_files() {
    local pkg="$1"
    if [ -f "${INSTALLED_DB}/${pkg}/files" ]; then
        cat "${INSTALLED_DB}/${pkg}/files"
    fi
}
