#!/usr/bin/env bash
set -u

show_help() {
  cat <<'HELP'
Diagnostic CLI

Usage:
  diagnostic.sh help
  diagnostic.sh system
  diagnostic.sh disk [path]

Commands:
  help          Show this help message.
  system        Print basic system information.
  disk [path]   Print disk usage for path (default: /).
HELP
}

system_info() {
  echo "Hostname: $(hostname 2>/dev/null || echo unknown)"
  echo "User: $(id -un 2>/dev/null || echo unknown)"
  echo "Kernel: $(uname -sr 2>/dev/null || echo unknown)"
  echo "Uptime: $(uptime 2>/dev/null || echo unknown)"
}

disk_info() {
  local target="${1:-/}"
  if [[ ! -e "$target" ]]; then
    echo "Error: path does not exist: $target" >&2
    return 2
  fi
  echo "Disk usage for: $target"
  df -Ph "$target"
}

COMMAND="${1:-help}"
case "$COMMAND" in
  help|-h|--help)
    show_help
    ;;
  system)
    system_info
    ;;
  disk)
    disk_info "${2:-/}"
    ;;
  *)
    echo "Error: unknown command '$COMMAND'." >&2
    show_help >&2
    exit 2
    ;;
esac
