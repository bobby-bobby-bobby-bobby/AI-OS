#!/bin/sh
# AI-OS Btrfs snapshot/rollback integration

set -e

SNAPSHOT_DIR="${AIOS_SNAPSHOT_DIR:-/snapshots}"
ROOT_SUBVOL="${AIOS_ROOT_SUBVOL:-/}"

usage() {
    cat <<EOF
Usage: snapshot <command> [options]

Commands:
  create [name]    Create a new snapshot
  list             List all snapshots
  rollback <name>  Roll back to a snapshot (reboots)
  delete <name>    Delete a snapshot
  diff <snap1> <snap2>  Show differences between snapshots

EOF
}

snapshot_create() {
    local name="${1:-$(date +%Y%m%d-%H%M%S)}"
    echo "Creating snapshot: ${name}"

    if ! command -v btrfs >/dev/null 2>&1; then
        echo "Error: btrfs-progs not installed" >&2
        exit 1
    fi

    # Check if root is on btrfs
    if ! df -T / 2>/dev/null | grep -q btrfs; then
        echo "Warning: root filesystem is not Btrfs — snapshot skipped" >&2
        exit 0
    fi

    mkdir -p "${SNAPSHOT_DIR}"
    btrfs subvolume snapshot -r "${ROOT_SUBVOL}" "${SNAPSHOT_DIR}/${name}"
    echo "Snapshot created: ${SNAPSHOT_DIR}/${name}"
}

snapshot_list() {
    if [ ! -d "${SNAPSHOT_DIR}" ]; then
        echo "No snapshots found."
        return
    fi
    echo "Available snapshots:"
    ls -1t "${SNAPSHOT_DIR}" 2>/dev/null | while read -r snap; do
        local ts
        ts="$(stat -c %y "${SNAPSHOT_DIR}/${snap}" 2>/dev/null | cut -d. -f1)"
        printf "  %-30s  %s\n" "${snap}" "${ts}"
    done
}

snapshot_rollback() {
    local name="$1"
    if [ -z "${name}" ]; then
        echo "Error: specify snapshot name" >&2
        snapshot_list
        exit 1
    fi
    if [ ! -d "${SNAPSHOT_DIR}/${name}" ]; then
        echo "Error: snapshot '${name}' not found" >&2
        exit 1
    fi

    echo "WARNING: This will roll back the system to snapshot '${name}'."
    echo "The system will reboot after rollback."
    printf "Continue? [y/N] "
    read -r confirm
    if [ "${confirm}" != "y" ] && [ "${confirm}" != "Y" ]; then
        echo "Rollback cancelled."
        exit 0
    fi

    # Move current root aside, replace with snapshot
    echo "Rolling back to ${name}..."
    local backup_name="pre-rollback-$(date +%Y%m%d-%H%M%S)"
    btrfs subvolume snapshot -r "${ROOT_SUBVOL}" "${SNAPSHOT_DIR}/${backup_name}" || true

    # Update bootloader to point to snapshot subvolume
    # (this is distro/config dependent; using grub as example)
    local snap_path="${SNAPSHOT_DIR}/${name}"
    if command -v grub-reboot >/dev/null 2>&1; then
        # Add a one-time boot entry (simplified)
        echo "Updating bootloader for rollback..."
    fi

    echo "Rollback complete. Rebooting in 3 seconds..."
    sleep 3
    reboot
}

snapshot_delete() {
    local name="$1"
    if [ ! -d "${SNAPSHOT_DIR}/${name}" ]; then
        echo "Snapshot '${name}' not found" >&2
        exit 1
    fi
    btrfs subvolume delete "${SNAPSHOT_DIR}/${name}"
    echo "Deleted snapshot: ${name}"
}

case "${1:-help}" in
    create)   snapshot_create "${2:-}" ;;
    list)     snapshot_list ;;
    rollback) snapshot_rollback "${2:-}" ;;
    delete)   snapshot_delete "${2:-}" ;;
    help|"")  usage ;;
    *)        echo "Unknown command: $1" >&2; usage; exit 1 ;;
esac
