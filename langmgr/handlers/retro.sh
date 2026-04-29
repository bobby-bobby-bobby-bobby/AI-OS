#!/bin/sh
# langmgr — handler for retro/DOSBox-based languages

set -e

ACTION="$1"
LANG="$2"
REGISTRY="$3"

DOSBOX_DIR="${HOME}/.aios/dosbox"
RETRO_DIR="${DOSBOX_DIR}/retro"

install_retro() {
    echo "Setting up retro language: ${LANG}"

    if ! command -v dosbox >/dev/null 2>&1; then
        echo "DOSBox not installed. Installing..."
        aipkg install dosbox 2>/dev/null || \
        apt-get install -y dosbox 2>/dev/null || \
        echo "Warning: Could not install DOSBox automatically"
    fi

    mkdir -p "${RETRO_DIR}/${LANG}"

    case "${LANG}" in
        qbasic)
            cat > "${RETRO_DIR}/${LANG}/README.md" <<EOF
# QBasic via DOSBox

QBasic 1.1 requires the original Microsoft QBasic files.
Due to copyright, they cannot be distributed automatically.

You can obtain them from:
- FreeDOS project: https://www.freedos.org/
- The QBasic files are available for free download from Microsoft

Place QBASIC.EXE and QBASIC.HLP in: ${RETRO_DIR}/${LANG}/

Then run: lang run qbasic <file.bas>
EOF
            ;;
        gwbasic)
            cat > "${RETRO_DIR}/${LANG}/README.md" <<EOF
# GW-BASIC via DOSBox

GW-BASIC is available as freeware from Microsoft.
Download GWBASIC.EXE and place it in: ${RETRO_DIR}/${LANG}/
EOF
            ;;
        turbo_pascal)
            cat > "${RETRO_DIR}/${LANG}/README.md" <<EOF
# Turbo Pascal via DOSBox

Turbo Pascal is available for free from Borland/Embarcadero.
Download and extract to: ${RETRO_DIR}/${LANG}/
EOF
            ;;
    esac

    echo "Setup guide written to: ${RETRO_DIR}/${LANG}/README.md"
    echo "Follow the instructions to complete the ${LANG} installation."
}

case "${ACTION}" in
    install) install_retro ;;
    *)       echo "Unknown action: ${ACTION}" >&2; exit 1 ;;
esac
