#!/bin/sh
# UPCL — Kali Linux tools handler

set -e

KALI_MIRROR="http://http.kali.org/kali"
KALI_DIST="kali-rolling"
KALI_CACHE="/var/cache/upcl/kali"

kali_install() {
    local tool="$1"
    echo "Kali: Installing ${tool}..."

    mkdir -p "${KALI_CACHE}"

    # If apt is available (Debian-based host), add Kali repo temporarily
    if command -v apt-get >/dev/null 2>&1; then
        # Check if Kali repo is already configured
        if ! grep -q "kali.org" /etc/apt/sources.list 2>/dev/null && \
           ! ls /etc/apt/sources.list.d/kali*.list 2>/dev/null | grep -q kali; then
            cat > /tmp/kali-tools.list <<EOF
deb [arch=amd64 trusted=yes] ${KALI_MIRROR} ${KALI_DIST} main contrib non-free
EOF
            echo "Kali: Temporarily adding Kali repository..."
            # Don't permanently add; just download and install the .deb
        fi

        # Try direct download approach
        local deb_url="${KALI_MIRROR}/pool/main/${tool:0:1}/${tool}/${tool}_*.deb"
        echo "Kali: Attempting to install via apt: ${tool}"
        apt-get install -y --no-install-recommends "${tool}" 2>/dev/null || {
            echo "Kali: Package not found in current repos" >&2
            echo "  Hint: Add Kali repos to /etc/apt/sources.list.d/ manually" >&2
            exit 1
        }
    elif command -v upcl >/dev/null 2>&1; then
        # Try downloading Kali .deb directly
        echo "Kali: apt not available, trying direct download..."
        local deb_file="${KALI_CACHE}/${tool}.deb"
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL -o "${deb_file}" \
                "${KALI_MIRROR}/pool/main/${tool:0:1}/${tool}/$(curl -fsSL "${KALI_MIRROR}/pool/main/${tool:0:1}/${tool}/" 2>/dev/null | grep -oE "${tool}_[^\"]+amd64.deb" | tail -1)" && \
            upcl install "${deb_file}"
        fi
    else
        echo "Kali: Cannot install without apt or network access" >&2
        exit 1
    fi

    echo "Kali: ${tool} installed"
}

kali_list() {
    echo "Kali Tools available (common):"
    cat <<EOF
  nmap            Network scanner
  metasploit-framework  Penetration testing framework
  aircrack-ng     WiFi security auditing
  burpsuite       Web application security
  sqlmap          SQL injection tool
  wireshark       Network protocol analyzer
  hashcat         Password recovery
  john            John the Ripper password cracker
  hydra           Network login cracker
  nikto           Web server scanner
  gobuster        Directory/file brute-forcer
  enum4linux      SMB enumeration
  maltego         Open-source intelligence
  (and hundreds more at https://tools.kali.org)
EOF
}

case "${1:-}" in
    install) kali_install "$2" ;;
    list)    kali_list ;;
    *)       echo "Usage: kali.sh install|list <tool>" >&2; exit 1 ;;
esac
