#!/bin/sh
set -eu
state_root="${AIOS_STATE_ROOT:-/var/lib/aios-update}"
log="${AIOS_LOG_FILE:-/var/log/update-daemon.log}"
channel_file="$state_root/channel"
current_file="$state_root/current-version"
rollback_file="$state_root/rollback-stack"
schedule_file="$state_root/schedule"
repo_root="${AIOS_UPDATE_REPO:-store/repo/updates}"
mkdir -p "$state_root" "$(dirname "$log")"
[ -f "$channel_file" ] || echo stable > "$channel_file"
[ -f "$current_file" ] || echo 0.0.0 > "$current_file"
[ -f "$rollback_file" ] || : > "$rollback_file"

log_msg(){ echo "$(date -u +%FT%TZ) $*" >> "$log"; }
latest_for_channel(){ awk -F, -v c="$1" '$2==c{print $1","$3}' "$repo_root/index.csv" | tail -n1; }

cmd="${1:-status}"
case "$cmd" in
  channel)
    action="${2:-get}"; value="${3:-}"
    if [ "$action" = "get" ]; then cat "$channel_file"; else echo "$value" > "$channel_file"; fi ;;
  check)
    ch=$(cat "$channel_file")
    latest=$(latest_for_channel "$ch" || true)
    [ -n "$latest" ] || { echo "no update"; exit 0; }
    cur=$(cat "$current_file")
    ver=$(echo "$latest" | cut -d, -f1)
    delta=$(echo "$latest" | cut -d, -f2)
    echo "current=$cur latest=$ver channel=$ch delta=$delta" ;;
  changelog)
    ver="${2:-}"
    [ -n "$ver" ] || ver=$(latest_for_channel "$(cat "$channel_file")" | cut -d, -f1)
    cat "$repo_root/changelogs/$ver.txt" ;;
  apply)
    target="${2:-}"
    [ -n "$target" ] || target=$(latest_for_channel "$(cat "$channel_file")" | cut -d, -f1)
    cur=$(cat "$current_file")
    echo "$cur" >> "$rollback_file"
    echo "$target" > "$current_file"
    echo "delta-applied:$cur->$target" > "$state_root/last-delta"
    log_msg "apply $target"
    echo "updated to $target" ;;
  schedule)
    echo "${2:-daily 02:00}" > "$schedule_file"; echo "scheduled $(cat "$schedule_file")" ;;
  rollback)
    prev=$(tail -n1 "$rollback_file" || true)
    [ -n "$prev" ] || { echo "no rollback point"; exit 1; }
    tmp="$rollback_file.tmp"; sed '$d' "$rollback_file" > "$tmp" && mv "$tmp" "$rollback_file"
    echo "$prev" > "$current_file"
    log_msg "rollback $prev"
    echo "rolled back to $prev" ;;
  status)
    echo "version=$(cat "$current_file") channel=$(cat "$channel_file") schedule=$(cat "$schedule_file" 2>/dev/null || echo manual)" ;;
  *) echo "usage: update-daemon.sh {status|check|apply [ver]|rollback|changelog [ver]|channel get|channel set <stable|beta|nightly>|schedule <expr>}"; exit 1 ;;
esac
