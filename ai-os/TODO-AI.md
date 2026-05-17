# AI-OS Implementation Plan (Ordered and Actionable)

This roadmap converts `SPEC.md` into concrete, dependency-aware work. The first section is the **current execution batch** requested now (skeleton generation).

## Batch 0 (Now): Foundation Scaffolding
- [x] Expand task plan with explicit ordering and milestones.
- [x] Create missing top-level module directories: `installer/`, `desktop/`, `compatibility/`, `docs/`, `branding/`, and security submodules.
- [x] Add baseline README files and executable skeletons for:
  - init system extension points
  - package manager extension points
  - shell extension points
  - UPCL extension points
  - desktop components
  - browser selection flow
  - VM wrappers
  - language manager handlers
  - security integrations
  - installer flow
  - documentation structure
- [ ] Normalize old typo path `compatability/` -> `compatibility/` with compatibility shims and migration notes.

## Batch 1: Build + Bootability Baseline
- [ ] Implement `build/build-rootfs.sh` to assemble init, shell, base configs, and fallback toolset.
- [ ] Implement `build/build-iso.sh` with GRUB config generation and EFI+BIOS support.
- [ ] Implement `build/qemu-run.sh` smoke boot (serial console + optional GUI mode).
- [ ] Add `build/build-initramfs.sh` and `build/kernel-config.sh` wrappers.
- [ ] Add CI-style local smoke script that verifies generated ISO artifact layout.

## Batch 2: Init + Service Lifecycle (PID 1 Track)
- [ ] Complete `init/init.c` as PID 1 finite-state boot controller.
- [ ] Complete mount sequencing (`mount.c`) and fsck/rollback hooks.
- [ ] Complete service manager in `service.c` with unit parser and dependency order.
- [ ] Complete logging pipeline (`log.c`) and persist to `/var/log`.
- [ ] Complete TTY spawning/recovery (`tty.c`) on tty1-tty6.
- [ ] Add shutdown/reboot path, rc hooks, and service unit docs.

## Batch 3: Userland Shell + Core Utilities
- [ ] Complete `aish` parser, builtins, history, prompt, and job control.
- [ ] Implement core utility set in `userland/coreutils/`.
- [ ] Wire BusyBox/ToyBox fallback wrappers when native tools are absent.

## Batch 4: Package Management + UPCL
- [ ] Complete `aipkg` command surface: install/remove/update/search/list.
- [ ] Complete resolver/fetch/install/verify library scripts.
- [ ] Complete UPCL handlers (deb/rpm/pkgbuild/appimage/flatpak + optional snap/nix).
- [ ] Integrate distro adapters (Kali, Fedora, openSUSE rollback, MX).
- [ ] Integrate Btrfs snapshot/rollback hooks around package transactions.

## Batch 5: Installer + Hardware Enablement
- [ ] Implement non-interactive + TUI installer orchestrator.
- [ ] Implement partition/format/install/bootloader/user setup modules.
- [ ] Add hardware detection and driver recommendation/install logic.
- [ ] Add encrypted-home setup path (LUKS/fscrypt).

## Batch 6: Desktop Environment + First-Boot UX
- [ ] Implement WM/compositor baseline.
- [ ] Implement panel, launcher, settings, notifications, tray support.
- [ ] Implement rounded/smooth default theme system and branding assets.
- [ ] Implement first-boot browser selector + reconfiguration UI.

## Batch 7: VMs, Android, Windows Compatibility, langmgr
- [ ] Complete specialized VM wrappers and template configs.
- [ ] Integrate Waydroid + microG scripts and app install UI.
- [ ] Integrate Wine + Proton wrappers and compatibility UI.
- [ ] Complete `langmgr` registry and handlers for modern/legacy/esoteric/academic/retro/vm-based runtimes.

## Batch 8: Security, Hardening, and Policy Defaults
- [ ] Add AppArmor/SELinux policy stubs.
- [ ] Add Firejail/Bubblewrap wrappers and profiles.
- [ ] Add firewall defaults + DNS-level filtering + browser hardening hooks.
- [ ] Add universal uninstaller covering native/sandboxed/VM app surfaces.

## Batch 9: Documentation, QA, and Release Readiness
- [ ] Write user, developer, troubleshooting, onboarding, architecture, security docs.
- [ ] Add man pages for init/aish/aipkg/lang/run/vm-manager.
- [ ] Build verification matrix: boot in QEMU, installer flow, package flow, rollback flow, browser flow, VM flow.
- [ ] Prepare alpha release checklist and known-issues policy.
