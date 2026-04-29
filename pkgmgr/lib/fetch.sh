#!/bin/sh
# aipkg — Package fetching functions

CACHE_DIR="${AIPKG_CACHE:-/var/cache/aipkg/packages}"

fetch_init() {
    mkdir -p "${CACHE_DIR}"
}

# Fetch a URL to a local file
fetch_url() {
    local url="$1"
    local dest="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL -o "${dest}" "${url}"
    elif command -v wget >/dev/null 2>&1; then
        wget -q -O "${dest}" "${url}"
    else
        echo "aipkg: no download tool found (curl or wget required)" >&2
        return 1
    fi
}

# Read repository list and update index files
repo_update() {
    echo "Updating package repositories..."
    if [ ! -f "${AIPKG_REPOS}" ]; then
        echo "aipkg: no repos configured at ${AIPKG_REPOS}" >&2
        return 1
    fi
    mkdir -p "${CACHE_DIR}/indexes"
    while IFS= read -r line; do
        # Skip comments and blank lines
        case "$line" in
            '#'*|'') continue ;;
        esac
        local repo_url="$line"
        local repo_name
        repo_name="$(echo "${repo_url}" | tr '/:.' '_')"
        echo "  Fetching: ${repo_url}"
        fetch_url "${repo_url}/INDEX" "${CACHE_DIR}/indexes/${repo_name}" || true
    done < "${AIPKG_REPOS}"
    echo "Package lists updated."
}

# Find package in repo indexes
repo_find_package() {
    local pkg="$1"
    if [ -d "${CACHE_DIR}/indexes" ]; then
        for idx in "${CACHE_DIR}/indexes/"*; do
            [ -f "$idx" ] || continue
            if grep -q "^${pkg}:" "$idx" 2>/dev/null; then
                grep "^${pkg}:" "$idx" | head -1
                return 0
            fi
        done
    fi
    return 1
}

# Download a package to cache
fetch_package() {
    local pkg="$1"
    local version="$2"
    local repo_url="$3"

    local filename="${pkg}-${version}.aipkg"
    local cache_path="${CACHE_DIR}/${filename}"

    if [ -f "${cache_path}" ]; then
        echo "Using cached: ${filename}"
        echo "${cache_path}"
        return 0
    fi

    echo "Downloading ${pkg} ${version}..."
    fetch_url "${repo_url}/packages/${filename}" "${cache_path}" || return 1
    echo "${cache_path}"
}

pkg_search() {
    local query="$1"
    echo "Searching for: ${query}"
    if [ ! -d "${CACHE_DIR}/indexes" ]; then
        echo "No package index. Run 'aipkg update' first."
        return 1
    fi
    grep -h "${query}" "${CACHE_DIR}/indexes/"* 2>/dev/null || echo "No results found."
}
