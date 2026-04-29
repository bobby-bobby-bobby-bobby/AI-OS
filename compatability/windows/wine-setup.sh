#!/bin/sh
# AI-OS Wine + Proton setup

set -e

echo "=== AI-OS Windows Compatibility Setup ==="

# Detect architecture
ARCH="$(uname -m)"

# Install Wine
echo "Installing Wine..."
if command -v apt-get >/dev/null 2>&1; then
    # Add Wine PPA/repo
    dpkg --add-architecture i386 2>/dev/null || true
    apt-get update -q
    apt-get install -y wine wine32 wine64 winetricks 2>/dev/null || \
        apt-get install -y wine 2>/dev/null || \
        echo "Warning: Wine installation failed"
elif command -v dnf >/dev/null 2>&1; then
    dnf install -y wine 2>/dev/null || true
fi

# Install Proton (via Proton-GE)
echo "Installing Proton-GE..."
PROTON_DIR="${HOME}/.steam/root/compatibilitytools.d"
mkdir -p "${PROTON_DIR}"

# Get latest Proton-GE release
if command -v curl >/dev/null 2>&1; then
    PROTON_URL="$(curl -fsSL https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest \
        2>/dev/null | grep -o '"browser_download_url": "[^"]*\.tar\.gz"' | \
        grep -o 'https://[^"]*' | head -1)"
    if [ -n "${PROTON_URL}" ]; then
        echo "Downloading Proton-GE..."
        curl -L "${PROTON_URL}" | tar xz -C "${PROTON_DIR}/" && \
            echo "Proton-GE installed to ${PROTON_DIR}"
    fi
fi

echo ""
echo "=== Windows Compatibility Setup Complete ==="
echo "Run Windows apps: run-windows <program.exe>"
echo "Configure Wine:   winecfg"
echo "Install components: winetricks"
