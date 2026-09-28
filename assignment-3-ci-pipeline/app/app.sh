#!/usr/bin/env bash
set -u

show_help() {
  cat <<'HELP'
DevOps Diagnostic App

Usage:
  app.sh help
  app.sh system-info
  app.sh check-port <host> <port>

Commands:
  help                    Show this help message.
  system-info             Display host, user, kernel, and uptime information.
  check-port HOST PORT    Test whether a TCP port is reachable.
HELP
}

system_info() {
  echo "Hostname: $(hostname 2>/dev/null || echo unknown)"
  echo "User: $(id -un 2>/dev/null || echo unknown)"
  echo "Kernel: $(uname -sr 2>/dev/null || echo unknown)"
  echo "Uptime: $(uptime 2>/dev/null || echo unknown)"
}

check_port() {
  local host="${1:-}"
  local port="${2:-}"

  if [[ -z "$host" || -z "$port" ]]; then
    echo "Usage: $0 check-port <host> <port>" >&2
    return 2
  fi
  if [[ ! "$port" =~ ^[0-9]+$ ]] || (( port < 1 || port > 65535 )); then
    echo "Error: port must be an integer from 1 to 65535." >&2
    return 2
  fi

  if command -v nc >/dev/null 2>&1; then
    if nc -z -w 2 "$host" "$port" >/dev/null 2>&1; then
      echo "OPEN: $host:$port"
      return 0
    fi
  elif command -v timeout >/dev/null 2>&1; then
    if timeout 2 bash -c "</dev/tcp/$host/$port" >/dev/null 2>&1; then
      echo "OPEN: $host:$port"
      return 0
    fi
  fi

  echo "CLOSED/UNREACHABLE: $host:$port"
  return 1
}

if [[ $# -eq 0 ]]; then
  echo "Error: command is required." >&2
  show_help >&2
  exit 2
fi

COMMAND="$1"
shift
case "$COMMAND" in
  help|-h|--help)
    show_help
    ;;
  system-info)
    system_info
    ;;
  check-port)
    check_port "$@"
    ;;
  *)
    echo "Error: unknown command '$COMMAND'." >&2
    show_help >&2
    exit 2
    ;;
esac
