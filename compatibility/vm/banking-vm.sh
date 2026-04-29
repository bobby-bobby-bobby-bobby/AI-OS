#!/usr/bin/env bash
set -euo pipefail
name=${0##*/}
img=${AIOS_VM_IMAGE:-$HOME/.local/share/ai-os/vms/base.qcow2}
mem=${AIOS_VM_MEM:-4096}
cpus=${AIOS_VM_CPUS:-2}
qemu-system-x86_64 -enable-kvm -m "$mem" -smp "$cpus" -drive file="$img",if=virtio -name "$name" -net nic -net user
