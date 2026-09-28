#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/network-check.log"

usage() {
  echo "Usage: $0 <host> [port]" >&2
}

log() {
  printf '%s %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$*" >> "$LOG_FILE"
}

HOST="${1:-}"
PORT="${2:-}"

if [[ -z "$HOST" ]]; then
  usage
  log "invalid_host=missing"
  exit 2
fi

if [[ -n "$PORT" ]]; then
  if [[ ! "$PORT" =~ ^[0-9]+$ ]] || (( PORT < 1 || PORT > 65535 )); then
    echo "Error: port must be an integer from 1 to 65535." >&2
    log "host=$HOST invalid_port=$PORT"
    exit 2
  fi
fi

host_resolves() {
  if [[ "$HOST" == "localhost" || "$HOST" == "127.0.0.1" || "$HOST" == "::1" ]]; then
    return 0
  fi
  if command -v getent >/dev/null 2>&1; then
    getent hosts "$HOST" >/dev/null 2>&1
    return $?
  fi
  if command -v dscacheutil >/dev/null 2>&1; then
    dscacheutil -q host -a name "$HOST" 2>/dev/null | grep -q '^ip_address:'
    return $?
  fi
  ping -c 1 "$HOST" >/dev/null 2>&1
}

if ! host_resolves; then
  echo "UNREACHABLE: unable to resolve or reach host $HOST"
  log "status=unreachable host=$HOST${PORT:+ port=$PORT}"
  exit 1
fi

if [[ -z "$PORT" ]]; then
  echo "OK: host $HOST is reachable/resolvable."
  log "status=ok host=$HOST"
  exit 0
fi

if command -v nc >/dev/null 2>&1; then
  if nc -z -w 2 "$HOST" "$PORT" >/dev/null 2>&1; then
    echo "OK: $HOST:$PORT is reachable."
    log "status=ok host=$HOST port=$PORT"
    exit 0
  fi
else
  if command -v timeout >/dev/null 2>&1 && timeout 2 bash -c "</dev/tcp/$HOST/$PORT" >/dev/null 2>&1; then
    echo "OK: $HOST:$PORT is reachable."
    log "status=ok host=$HOST port=$PORT"
    exit 0
  fi
fi

echo "UNREACHABLE: $HOST:$PORT is not accepting TCP connections."
log "status=unreachable host=$HOST port=$PORT"
exit 1
