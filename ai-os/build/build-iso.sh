#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
AIOS_ROOT="$PROJECT_ROOT/ai-os"
ISO_ROOT="$AIOS_ROOT/iso"
ROOTFS="$AIOS_ROOT/rootfs"
ISO="$AIOS_ROOT/ai-os.iso"

mkdir -p "$ISO_ROOT/boot/grub"
[ -f "$AIOS_ROOT/kernel/linux/arch/x86/boot/bzImage" ] && cp "$AIOS_ROOT/kernel/linux/arch/x86/boot/bzImage" "$ISO_ROOT/boot/vmlinuz" || touch "$ISO_ROOT/boot/vmlinuz"

( cd "$ROOTFS" && find . -print0 | cpio --null -ov --format=newc ) | gzip -9 > "$ISO_ROOT/boot/initramfs.img"
mkdir -p "$ISO_ROOT/boot/modules"
[ -d "$AIOS_ROOT/kernel/modules" ] && cp -a "$AIOS_ROOT/kernel/modules/." "$ISO_ROOT/boot/modules/" || true

cat > "$ISO_ROOT/boot/grub/grub.cfg" <<GRUB
set timeout=3
set default=0
menuentry "AI-OS First Boot" {
  linux /boot/vmlinuz console=ttyS0 init=/sbin/init
  initrd /boot/initramfs.img
}
GRUB
mkdir -p "$ISO_ROOT/boot/firstboot"
cp -f "$PROJECT_ROOT/installer/firstboot-wizard.sh" "$ISO_ROOT/boot/firstboot/" 2>/dev/null || true
cp -f "$PROJECT_ROOT/apps/browser-picker/browser-picker.sh" "$ISO_ROOT/boot/firstboot/" 2>/dev/null || true
cp -f "$PROJECT_ROOT/apps/ui-picker/ui-picker.sh" "$ISO_ROOT/boot/firstboot/" 2>/dev/null || true
mkdir -p "$ISO_ROOT/boot/branding"
[ -d "$PROJECT_ROOT/branding" ] && cp -a "$PROJECT_ROOT/branding/." "$ISO_ROOT/boot/branding/" || true

grub-mkrescue -o "$ISO" "$ISO_ROOT"
echo "ISO created at $ISO"
