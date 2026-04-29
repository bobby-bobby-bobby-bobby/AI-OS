# UPCL — Universal Package Compatibility Layer

UPCL allows installing and running packages from any major Linux distribution
on AI-OS, regardless of the native package format.

## Supported Formats

| Format   | Handler             | Distros                    |
|----------|---------------------|----------------------------|
| DEB      | handlers/deb.sh     | Debian, Ubuntu, Mint, Kali |
| RPM      | handlers/rpm.sh     | Fedora, openSUSE, RHEL     |
| PKGBUILD | handlers/pkgbuild.sh| Arch Linux, Manjaro         |
| AppImage | handlers/appimage.sh| Universal                  |
| Flatpak  | handlers/flatpak.sh | Universal                  |
| Snap     | handlers/snap.sh    | Ubuntu (optional)          |
| Nix      | handlers/nix.sh     | NixOS (optional)           |

## Usage

```sh
upcl install package.deb
upcl install package.rpm
upcl install package.AppImage
upcl install flatpak:<app-id>
upcl install kali:<tool>
```
