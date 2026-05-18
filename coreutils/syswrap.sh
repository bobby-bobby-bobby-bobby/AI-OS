#!/bin/sh
set -eu
cmd=$(basename "$0")
case "$cmd" in
  df) /bin/df "$@" ;;
  du) /usr/bin/du "$@" ;;
  free) /usr/bin/free "$@" ;;
  ps) /bin/ps "$@" ;;
  top) /usr/bin/top "$@" ;;
  killall|pkill|pgrep) /usr/bin/$cmd "$@" ;;
  sha256sum|md5sum|base64|uuidgen|tar|gzip|unzip|mount|umount|lsblk|blkid) /usr/bin/$cmd "$@" ;;
  aiservicectl) exec ./coreutils/aiservicectl.sh "$@" ;;
  *) echo "unsupported $cmd"; exit 1 ;;
esac
