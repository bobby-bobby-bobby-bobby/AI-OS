### `TODO-AI.md`

# Tasks for AI

## Core Boot & Build
[ ] Generate detailed build plan based on SPEC.md.
[ ] Implement `build-rootfs.sh` to assemble a minimal root filesystem.
[ ] Implement `build-iso.sh` to create a bootable ISO.
[ ] Implement `qemu-run.sh` to boot the ISO in QEMU.
[ ] Implement kernel build wrapper using `kernel/` fetched by `fetch-kernel.sh`.

## Init & Services
[ ] Implement init system in `init/` (PID 1, mounts, services, TTYs).
[ ] Implement service manager (simple unit format, start/stop/restart).
[ ] Implement logging system.

## Shell & Userland
[ ] Implement `aish` shell in `userland/aish/`.
[ ] Implement core utilities (ls, cp, mv, rm, cat, ps, kill, mkdir, etc.).
[ ] Integrate BusyBox/ToyBox as fallback where needed.

## Package Management & UPCL
[ ] Implement `aipkg` package manager in `pkgmgr/`.
[ ] Implement Universal Package Compatibility Layer (UPCL) in `compatibility/packages/`.
[ ] Support DEB, RPM, PKGBUILD, AppImage, Flatpak, Snap (optional), Nix (optional).
[ ] Implement Kali tools integration.
[ ] Implement Fedora/openSUSE tools integration.
[ ] Implement MX Tools integration.
[ ] Implement Btrfs snapshot/rollback integration (openSUSE-style).

## Installer
[ ] Implement installer in `installer/` with auto-partitioning and auto-formatting.
[ ] Implement bootloader setup (GRUB/Syslinux).
[ ] Implement user creation and basic system configuration.
[ ] Implement hardware detection and driver auto-install hooks.

## Desktop Environment
[ ] Implement window manager in `desktop/wm/`.
[ ] Implement panel/dock and launcher.
[ ] Implement settings app.
[ ] Implement theme engine and theme packs (smooth, rounded UI).
[ ] Implement wallpapers, icons, branding in `branding/`.

## Compatibility Layers
[ ] Implement NVIDIA driver integration scripts in `compatibility/nvidia/`.
[ ] Implement AMD/Intel GPU setup scripts.
[ ] Implement Waydroid + microG integration in `compatibility/android/`.
[ ] Implement Wine + Proton integration in `compatibility/windows/`.
[ ] Implement Windows Legacy Mode VM wrapper (QEMU-based).
[ ] Implement specialized VMs: banking, suspicious files, developer, optional browser VM.

## Language Runtime Manager (langmgr)
[ ] Implement language registry format in `langmgr/registry.yaml` (or JSON).
[ ] Implement `lang` CLI for `lang install <language>`.
[ ] Implement `run <file>` universal runner.
[ ] Integrate DOSBox for retro languages (QBasic, GW-BASIC, Turbo Pascal, etc.).
[ ] Integrate Wine/Windows VM for Windows-only language tools.
[ ] Add initial language entries (Python, Rust, Go, Java, C#, BASIC, Fortran, COBOL, etc.).

## Privacy & Security
[ ] Implement AppArmor/SELinux policy generation in `security/`.
[ ] Implement Firejail/Bubblewrap profiles for key apps.
[ ] Implement Flatpak sandboxing defaults.
[ ] Implement encrypted home integration (LUKS/fscrypt) in installer.
[ ] Implement firewall configuration and defaults.
[ ] Implement DNS-level ad/tracker blocking.
[ ] Integrate uBlock Origin into default browser profile.
[ ] Implement browser isolation (sandbox/micro-VM) wrapper.

## VMs & Virtualization
[ ] Implement QEMU wrapper scripts in `compatibility/vm/`.
[ ] Implement script to download Windows 10 evaluation ISO (or similar).
[ ] Implement VM templates for banking, suspicious files, dev, browser.
[ ] Implement simple VM management UI/CLI.

## Docs & UX
[ ] Generate man pages for core tools.
[ ] Generate user guide in `docs/user-guide.md`.
[ ] Generate developer guide in `docs/dev-guide.md`.
[ ] Generate troubleshooting guide in `docs/troubleshooting.md`.
[ ] Generate onboarding experience (first boot wizard).

## Maintenance
[ ] Implement update mechanism for system and AI-generated components.
[ ] Implement rollback mechanism using Btrfs snapshots.
[ ] Implement universal uninstaller for system, sandboxed, and VM-based apps.
