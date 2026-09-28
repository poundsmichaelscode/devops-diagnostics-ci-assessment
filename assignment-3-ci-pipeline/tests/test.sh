#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
APP="./app/app.sh"
PASS=0
FAIL=0

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

"$APP" help >/dev/null 2>&1 && pass "help succeeds" || fail "help fails"
"$APP" system-info >/dev/null 2>&1 && pass "system-info succeeds" || fail "system-info fails"

"$APP" >/dev/null 2>&1
[[ $? -eq 2 ]] && pass "missing command returns 2" || fail "missing command should return 2"

for port in abc 0 65536; do
  "$APP" check-port localhost "$port" >/dev/null 2>&1
  [[ $? -eq 2 ]] && pass "rejects invalid port $port" || fail "should reject invalid port $port"
done

"$APP" invalid-command >/dev/null 2>&1
[[ $? -ne 0 ]] && pass "invalid command fails" || fail "invalid command should fail"

bash -n "$APP" && pass "app syntax" || fail "app syntax"

echo "Passed: $PASS"
echo "Failed: $FAIL"
[[ $FAIL -eq 0 ]]
