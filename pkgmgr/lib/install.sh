#!/bin/sh
# aipkg — Package installation/removal functions

pkg_install() {
    local pkg="$1"
    echo "Installing: ${pkg}"

    db_init
    fetch_init

    if db_is_installed "${pkg}"; then
        echo "Package '${pkg}' is already installed."
        return 0
    fi

    # Resolve dependencies first
    if [ "${NO_DEPS:-0}" = "0" ]; then
        resolve_deps "${pkg}" || return 1
    fi

    # Find package in repos
    local repo_info
    repo_info="$(repo_find_package "${pkg}" 2>/dev/null)" || {
        echo "aipkg: package '${pkg}' not found in repositories" >&2
        echo "  Try: aipkg update"
        return 1
    }

    local version repo_url
    version="$(echo "${repo_info}" | cut -d: -f2)"
    repo_url="$(echo "${repo_info}" | cut -d: -f3)"

    # Download
    local cache_file
    cache_file="$(fetch_package "${pkg}" "${version}" "${repo_url}")" || return 1

    # Extract and install
    _extract_aipkg "${cache_file}" "${pkg}" "${version}"
}

_extract_aipkg() {
    local archive="$1"
    local pkg="$2"
    local version="$3"
    local tmpdir
    tmpdir="$(mktemp -d /run/aipkg.XXXXXX)"

    tar xf "${archive}" -C "${tmpdir}" 2>/dev/null || {
        echo "aipkg: failed to extract ${archive}" >&2
        rm -rf "${tmpdir}"
        return 1
    }

    # Run pre-install script if present
    if [ -x "${tmpdir}/INSTALL" ]; then
        sh "${tmpdir}/INSTALL" pre-install
    fi

    # Install files
    if [ -d "${tmpdir}/data" ]; then
        local files
        files="$(find "${tmpdir}/data" -type f | sed "s|${tmpdir}/data||")"
        cp -r "${tmpdir}/data/". /
        db_save_files "${pkg}" ${files}
    fi

    # Run post-install script
    if [ -x "${tmpdir}/INSTALL" ]; then
        sh "${tmpdir}/INSTALL" post-install
    fi

    # Record installation
    local desc=""
    if [ -f "${tmpdir}/PKGINFO" ]; then
        desc="$(grep '^Description=' "${tmpdir}/PKGINFO" | cut -d= -f2)"
    fi
    db_install_record "${pkg}" "${version}" "${desc}"

    rm -rf "${tmpdir}"
    echo "Installed: ${pkg} ${version}"
}

pkg_remove() {
    local pkg="$1"
    echo "Removing: ${pkg}"

    if ! db_is_installed "${pkg}"; then
        echo "Package '${pkg}' is not installed."
        return 1
    fi

    # Run pre-remove script if present
    local uninstall_script="${INSTALLED_DB}/${pkg}/UNINSTALL"
    if [ -x "${uninstall_script}" ]; then
        sh "${uninstall_script}" pre-remove
    fi

    # Remove installed files
    db_get_files "${pkg}" | while IFS= read -r f; do
        [ -f "$f" ] && rm -f "$f"
    done

    # Remove database record
    db_remove_record "${pkg}"
    echo "Removed: ${pkg}"
}

pkg_upgrade() {
    echo "Checking for upgrades..."
    repo_update || true
    # TODO: compare installed versions against repo index
    echo "System is up to date."
}

pkg_info() {
    local pkg="$1"
    if db_is_installed "${pkg}"; then
        echo "=== ${pkg} (installed) ==="
        cat "${INSTALLED_DB}/${pkg}/PKGINFO" 2>/dev/null || true
    else
        local info
        info="$(repo_find_package "${pkg}" 2>/dev/null)" || {
            echo "Package '${pkg}' not found." >&2
            return 1
        }
        echo "=== ${pkg} (available) ==="
        echo "${info}"
    fi
}

pkg_clean() {
    echo "Cleaning package cache..."
    rm -f "${CACHE_DIR}"/*.aipkg 2>/dev/null || true
    echo "Cache cleaned."
}

pkg_verify() {
    local pkg="$1"
    if ! db_is_installed "${pkg}"; then
        echo "Package '${pkg}' is not installed." >&2
        return 1
    fi
    echo "Verifying ${pkg}..."
    local files_ok=0 files_missing=0
    while IFS= read -r f; do
        if [ -e "$f" ]; then
            files_ok=$((files_ok + 1))
        else
            echo "  MISSING: $f"
            files_missing=$((files_missing + 1))
        fi
    done < <(db_get_files "${pkg}")
    echo "${pkg}: ${files_ok} OK, ${files_missing} missing"
    [ "${files_missing}" -eq 0 ]
}

btrfs_snapshot() {
    echo "Creating Btrfs snapshot..."
    if ! command -v btrfs >/dev/null 2>&1; then
        echo "btrfs-progs not available, skipping snapshot." >&2
        return 0
    fi
    local snap_dir="/snapshots"
    local snap_name
    snap_name="$(date +%Y%m%d-%H%M%S)-pre-install"
    mkdir -p "${snap_dir}"
    btrfs subvolume snapshot / "${snap_dir}/${snap_name}" && \
        echo "Snapshot created: ${snap_dir}/${snap_name}"
}
