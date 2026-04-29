#!/bin/sh
# AI-OS VM Manager
# Central management CLI for all virtual machines.

set -e

VM_DIR="${HOME}/.aios/vms"
TEMPLATES_DIR="$(dirname "$0")/templates"

usage() {
    cat <<EOF
AI-OS VM Manager

Usage: vm-manager <command> [options]

Commands:
  list                  List all VMs
  create <name> <type>  Create a new VM (types: generic, windows, dev, banking)
  start  <name>         Start a VM
  stop   <name>         Stop a VM
  delete <name>         Delete a VM
  status <name>         Show VM status

  windows-legacy        Launch Windows Legacy Mode VM
  banking               Launch Banking VM (hardened)
  suspicious [file]     Launch Suspicious File VM (disposable)
  dev                   Launch Developer VM
  browser               Launch Browser Isolation VM

Options:
  -m <MB>    Memory in MB (default: 2048)
  -c <n>     CPU cores (default: 2)
  -h         Show this help

EOF
}

vm_list() {
    mkdir -p "${VM_DIR}"
    echo "Virtual Machines:"
    ls "${VM_DIR}"/*.conf 2>/dev/null | while read -r conf; do
        local name
        name="$(basename "${conf}" .conf)"
        local running
        running="stopped"
        if pgrep -f "qemu.*${name}" >/dev/null 2>&1; then
            running="running"
        fi
        printf "  %-20s  %s\n" "${name}" "${running}"
    done || echo "  (no VMs found)"
}

vm_create() {
    local name="$1"
    local type="${2:-generic}"
    local mem="${MEM:-2048}"
    local cpus="${CPUS:-2}"

    mkdir -p "${VM_DIR}"
    local conf="${VM_DIR}/${name}.conf"

    if [ -f "${conf}" ]; then
        echo "VM '${name}' already exists." >&2
        exit 1
    fi

    cat > "${conf}" <<EOF
NAME=${name}
TYPE=${type}
MEMORY=${mem}
CPUS=${cpus}
DISK=${VM_DIR}/${name}.qcow2
CREATED=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

    # Create disk image
    if command -v qemu-img >/dev/null 2>&1; then
        local disk_size="20G"
        [ "${type}" = "banking" ] && disk_size="10G"
        qemu-img create -f qcow2 "${VM_DIR}/${name}.qcow2" "${disk_size}"
    fi

    echo "VM '${name}' created (type: ${type})"
}

vm_start() {
    local name="$1"
    local conf="${VM_DIR}/${name}.conf"

    if [ ! -f "${conf}" ]; then
        echo "VM '${name}' not found." >&2
        exit 1
    fi

    . "${conf}"
    local disk="${VM_DIR}/${name}.qcow2"
    local iso_opt=""
    if [ -n "${ISO:-}" ]; then
        iso_opt="-cdrom ${ISO} -boot d"
    fi

    echo "Starting VM: ${name}..."
    qemu-system-x86_64 \
        -name "${NAME}" \
        -m "${MEMORY}" \
        -smp "${CPUS}" \
        -drive "file=${disk},format=qcow2" \
        ${iso_opt} \
        -vga virtio \
        -nic "user,model=virtio" \
        -enable-kvm \
        -daemonize \
        -pidfile "${VM_DIR}/${name}.pid" 2>/dev/null || \
    qemu-system-x86_64 \
        -name "${NAME}" \
        -m "${MEMORY}" \
        -smp "${CPUS}" \
        -drive "file=${disk},format=qcow2" \
        ${iso_opt} \
        -vga std \
        -nic "user" \
        -daemonize \
        -pidfile "${VM_DIR}/${name}.pid"

    echo "VM '${name}' started."
}

vm_stop() {
    local name="$1"
    local pidfile="${VM_DIR}/${name}.pid"
    if [ -f "${pidfile}" ]; then
        kill "$(cat "${pidfile}")" 2>/dev/null && rm -f "${pidfile}"
        echo "VM '${name}' stopped."
    else
        echo "VM '${name}' is not running."
    fi
}

# Parse options
MEM=2048
CPUS=2

while [ $# -gt 0 ]; do
    case "$1" in
        -m) MEM="$2"; shift 2 ;;
        -c) CPUS="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        --)  shift; break ;;
        *)   break ;;
    esac
done

COMMAND="${1:-help}"
shift || true

case "${COMMAND}" in
    list)    vm_list ;;
    create)  vm_create "$1" "${2:-generic}" ;;
    start)   vm_start "$1" ;;
    stop)    vm_stop "$1" ;;
    delete)  rm -f "${VM_DIR}/${1}.conf" "${VM_DIR}/${1}.qcow2" "${VM_DIR}/${1}.pid" 2>/dev/null && echo "Deleted: $1" ;;
    windows-legacy) exec "$(dirname "$0")/windows-legacy.sh" "$@" ;;
    banking)  exec "$(dirname "$0")/banking-vm.sh" "$@" ;;
    suspicious) exec "$(dirname "$0")/suspicious-vm.sh" "$@" ;;
    dev)     exec "$(dirname "$0")/dev-vm.sh" "$@" ;;
    browser) exec "$(dirname "$0")/browser-vm.sh" "$@" ;;
    help|"") usage ;;
    *)       echo "Unknown command: ${COMMAND}" >&2; usage; exit 1 ;;
esac
