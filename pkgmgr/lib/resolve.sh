#!/bin/sh
# aipkg — Dependency resolver

resolve_deps() {
    local pkg="$1"
    local depth="${2:-0}"
    local max_depth=10

    if [ "${depth}" -ge "${max_depth}" ]; then
        echo "aipkg: dependency depth limit reached for ${pkg}" >&2
        return 1
    fi

    # Find package info
    local repo_info
    repo_info="$(repo_find_package "${pkg}" 2>/dev/null)" || return 0

    # Extract dependencies (simplified)
    local deps
    deps="$(echo "${repo_info}" | cut -d: -f4 | tr ',' ' ')"

    for dep in ${deps}; do
        [ -z "${dep}" ] && continue
        if db_is_installed "${dep}"; then
            continue
        fi
        echo "  Dependency: ${dep}"
        resolve_deps "${dep}" $((depth + 1)) || return 1
    done
    return 0
}
