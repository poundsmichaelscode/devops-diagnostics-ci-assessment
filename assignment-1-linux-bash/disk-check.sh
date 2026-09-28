#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/disk-check.log"

usage() {
  echo "Usage: $0 <threshold-percent 1-100> [path]" >&2
}

log() {
  printf '%s %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$*" >> "$LOG_FILE"
}

THRESHOLD="${1:-}"
TARGET_PATH="${2:-/}"

if [[ -z "$THRESHOLD" || ! "$THRESHOLD" =~ ^[0-9]+$ ]] || (( THRESHOLD < 1 || THRESHOLD > 100 )); then
  usage
  log "invalid_threshold=${THRESHOLD:-missing}"
  exit 2
fi

if [[ ! -e "$TARGET_PATH" ]]; then
  echo "Error: path does not exist: $TARGET_PATH" >&2
  log "invalid_path=$TARGET_PATH threshold=$THRESHOLD"
  exit 2
fi

USAGE_PERCENT="$(df -P "$TARGET_PATH" 2>/dev/null | awk 'NR==2 {gsub(/%/, "", $5); print $5}')"

if [[ -z "$USAGE_PERCENT" || ! "$USAGE_PERCENT" =~ ^[0-9]+$ ]]; then
  echo "Error: unable to determine disk usage for $TARGET_PATH" >&2
  log "disk_read_failed path=$TARGET_PATH threshold=$THRESHOLD"
  exit 1
fi

printf 'Path: %s\n' "$TARGET_PATH"
printf 'Disk usage: %s%%\n' "$USAGE_PERCENT"
printf 'Threshold: %s%%\n' "$THRESHOLD"

if (( USAGE_PERCENT >= THRESHOLD )); then
  echo "WARNING: disk usage is at or above threshold."
  log "status=warning path=$TARGET_PATH usage=${USAGE_PERCENT}% threshold=${THRESHOLD}%"
  exit 1
fi

echo "OK: disk usage is below threshold."
log "status=ok path=$TARGET_PATH usage=${USAGE_PERCENT}% threshold=${THRESHOLD}%"
exit 0
