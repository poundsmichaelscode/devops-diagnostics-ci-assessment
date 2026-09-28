#!/usr/bin/env bash
set -u

PASS=0
FAIL=0

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

APP="./app/diagnostic.sh"

bash -n "$APP" && pass "Bash syntax" || fail "Bash syntax"
"$APP" help >/dev/null 2>&1 && pass "help command" || fail "help command"
"$APP" system >/dev/null 2>&1 && pass "system command" || fail "system command"
"$APP" disk >/dev/null 2>&1 && pass "disk command" || fail "disk command"

"$APP" invalid-command >/dev/null 2>&1
RC=$?
[[ $RC -ne 0 ]] && pass "invalid command fails" || fail "invalid command should fail"

if command -v docker >/dev/null 2>&1; then
  docker compose config >/dev/null 2>&1 && pass "compose config" || fail "compose config"
fi

echo "Passed: $PASS"
echo "Failed: $FAIL"
[[ $FAIL -eq 0 ]]
