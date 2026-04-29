#!/bin/sh
# langmgr — handler for modern/systems languages (package-based install)

set -e

ACTION="$1"
LANG="$2"
REGISTRY="$3"

# Extract packages list from registry
get_packages() {
    awk -v lang="  ${LANG}:" '
        /^  [a-z_]+:/ { in_lang = ($0 ~ lang) }
        in_lang && /packages:/ { found=1; next }
        found && /^\s*-/ { gsub(/.*- */, ""); gsub(/\[|\]|,/, ""); print; if (!/,$/) found=0 }
        found && !/^\s*-/ { found=0 }
    ' "${REGISTRY}" | tr -d ' '
}

install_via_package_manager() {
    local pkgs
    pkgs="$(get_packages)"
    if [ -z "${pkgs}" ]; then
        echo "No packages defined for ${LANG}" >&2
        exit 1
    fi
    echo "Installing packages: ${pkgs}"
    if command -v apt-get >/dev/null 2>&1; then
        apt-get install -y ${pkgs}
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y ${pkgs}
    elif command -v pacman >/dev/null 2>&1; then
        pacman -S --noconfirm ${pkgs}
    elif command -v aipkg >/dev/null 2>&1; then
        for p in ${pkgs}; do aipkg install "${p}"; done
    else
        echo "No package manager found" >&2
        exit 1
    fi
}

install_via_script() {
    local cmd
    cmd="$(awk -v lang="  ${LANG}:" '
        /^  [a-z_]+:/ { in_lang = ($0 ~ lang) }
        in_lang && /cmd:/ { gsub(/.*cmd: *"?/, ""); gsub(/"$/, ""); print; exit }
    ' "${REGISTRY}")"
    if [ -n "${cmd}" ]; then
        echo "Running installer: ${cmd}"
        eval "${cmd}"
    fi
}

install_via_npm() {
    local pkgs
    pkgs="$(get_packages)"
    echo "Installing npm packages: ${pkgs}"
    npm install -g ${pkgs}
}

install_via_build() {
    local src
    src="$(awk -v lang="  ${LANG}:" '
        /^  [a-z_]+:/ { in_lang = ($0 ~ lang) }
        in_lang && /source:/ { gsub(/.*source: *"?/, ""); gsub(/"$/, ""); print; exit }
    ' "${REGISTRY}")"
    echo "Building from source: ${src}"
    if echo "${src}" | grep -q "^https://"; then
        local tmpdir
        tmpdir="$(mktemp -d /tmp/langmgr-build-XXXXXX)"
        git clone --depth=1 "${src}" "${tmpdir}" && \
            cd "${tmpdir}" && \
            make && make install && \
            cd / && rm -rf "${tmpdir}"
    else
        echo "Build source '${src}' requires manual setup" >&2
    fi
}

case "${ACTION}" in
    install-packages) install_via_package_manager ;;
    install-script)   install_via_script ;;
    install-npm)      install_via_npm ;;
    install-build)    install_via_build ;;
    *)                echo "Unknown action: ${ACTION}" >&2; exit 1 ;;
esac
