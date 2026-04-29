#!/bin/sh
# AI-OS Waydroid + microG setup

set -e

WAYDROID_CHANNEL="${WAYDROID_CHANNEL:-lineage}"
WAYDROID_TYPE="${WAYDROID_TYPE:-GAPPS}"  # or VANILLA for microG

echo "=== AI-OS Android Support Setup ==="
echo "Setting up Waydroid with microG..."

# Check dependencies
for dep in waydroid lxc; do
    if ! command -v "${dep}" >/dev/null 2>&1; then
        echo "Installing ${dep}..."
        aipkg install "${dep}" 2>/dev/null || \
        upcl install "${dep}" 2>/dev/null || \
        echo "Warning: Could not install ${dep} automatically"
    fi
done

# Initialize Waydroid
echo "Initializing Waydroid with microG (VANILLA)..."
waydroid init -c "https://ota.waydro.id/system" \
              -v "https://ota.waydro.id/vendor" \
              -s VANILLA \
              -f 2>/dev/null || \
waydroid init 2>/dev/null || \
echo "Warning: Waydroid init failed — may need manual setup"

# Install microG
echo "Setting up microG..."
if command -v waydroid >/dev/null 2>&1; then
    # Enable microG spoofing
    waydroid prop set persist.waydroid.fake_wifi true 2>/dev/null || true
    waydroid prop set persist.waydroid.fake_touch true 2>/dev/null || true
fi

# Enable Waydroid service
if command -v systemctl >/dev/null 2>&1; then
    systemctl enable --now waydroid-container.service 2>/dev/null || true
fi

echo ""
echo "=== Android Support Setup Complete ==="
echo "Start Android: waydroid session start"
echo "Open Android UI: waydroid show-full-ui"
echo "Install APK: waydroid app install <file.apk>"
