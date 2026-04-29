#!/bin/sh
# AI-OS Windows application launcher (Wine/Proton)

set -e

usage() {
    echo "Usage: run-windows [options] <program.exe> [args...]"
    echo ""
    echo "Options:"
    echo "  --proton       Use Proton instead of Wine (for Steam games)"
    echo "  --sandbox      Run in Firejail sandbox"
    echo "  --wine-prefix <dir>  Set WINEPREFIX"
    echo "  --vm           Run in Windows Legacy VM instead"
    echo "  -h, --help     Show this help"
}

USE_PROTON=0
USE_SANDBOX=0
USE_VM=0
WINEPREFIX="${WINEPREFIX:-${HOME}/.wine}"

while [ $# -gt 0 ]; do
    case "$1" in
        --proton)  USE_PROTON=1; shift ;;
        --sandbox) USE_SANDBOX=1; shift ;;
        --vm)      USE_VM=1; shift ;;
        --wine-prefix) WINEPREFIX="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        --)        shift; break ;;
        -*)        echo "Unknown option: $1" >&2; exit 1 ;;
        *)         break ;;
    esac
done

if [ $# -eq 0 ]; then
    echo "Error: no program specified" >&2
    usage
    exit 1
fi

PROGRAM="$1"
shift

# Use VM if requested
if [ "${USE_VM}" = "1" ]; then
    exec "$(dirname "$0")/../vm/windows-legacy.sh" run "${PROGRAM}" "$@"
fi

# Build command
if [ "${USE_PROTON}" = "1" ]; then
    PROTON_DIR="$(ls -d "${HOME}/.steam/root/compatibilitytools.d/Proton"* 2>/dev/null | sort -r | head -1)"
    if [ -z "${PROTON_DIR}" ]; then
        echo "Proton not found. Run: wine-setup.sh" >&2
        exit 1
    fi
    CMD="${PROTON_DIR}/proton run"
else
    CMD="wine"
    export WINEPREFIX
fi

if [ "${USE_SANDBOX}" = "1" ] && command -v firejail >/dev/null 2>&1; then
    exec firejail --profile=/etc/firejail/wine.profile ${CMD} "${PROGRAM}" "$@"
fi

exec ${CMD} "${PROGRAM}" "$@"
