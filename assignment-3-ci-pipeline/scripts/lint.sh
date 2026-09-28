#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

FILES=(app/app.sh scripts/lint.sh scripts/build.sh tests/test.sh)

for file in "${FILES[@]}"; do
  echo "Checking Bash syntax: $file"
  bash -n "$file"
done

if command -v shellcheck >/dev/null 2>&1; then
  echo "Running shellcheck..."
  shellcheck "${FILES[@]}"
else
  echo "shellcheck not installed; syntax validation completed."
fi

echo "Lint passed."
