#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/system-info.log"

log() {
  printf '%s %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$*" >> "$LOG_FILE"
}

HOSTNAME_VALUE="$(hostname 2>/dev/null || printf 'unknown')"
USER_VALUE="$(id -un 2>/dev/null || printf '%s' "${USER:-unknown}")"
KERNEL_VALUE="$(uname -sr 2>/dev/null || printf 'unknown')"
UPTIME_VALUE="$(uptime 2>/dev/null || printf 'unknown')"

printf 'Hostname: %s\n' "$HOSTNAME_VALUE"
printf 'User: %s\n' "$USER_VALUE"
printf 'Kernel: %s\n' "$KERNEL_VALUE"
printf 'Uptime: %s\n' "$UPTIME_VALUE"

log "hostname=$HOSTNAME_VALUE user=$USER_VALUE kernel=$KERNEL_VALUE uptime=$UPTIME_VALUE"
exit 0
