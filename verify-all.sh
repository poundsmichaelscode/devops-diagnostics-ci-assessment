#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_assignment_1() {
  echo "=== Assignment 1 ==="
  cd "$ROOT_DIR/assignment-1-linux-bash"
  bash -n system-info.sh disk-check.sh network-check.sh
  ./system-info.sh
  ./disk-check.sh 100 /
  ./network-check.sh localhost

  for bad in 0 101 abc; do
    set +e
    ./disk-check.sh "$bad" >/dev/null 2>&1
    rc=$?
    set -e
    [[ $rc -eq 2 ]]
  done

  set +e
  ./network-check.sh >/dev/null 2>&1
  [[ $? -ne 0 ]] || exit 1
  ./network-check.sh localhost 0 >/dev/null 2>&1
  [[ $? -eq 2 ]] || exit 1
  ./network-check.sh localhost 65536 >/dev/null 2>&1
  [[ $? -eq 2 ]] || exit 1
  ./network-check.sh localhost abc >/dev/null 2>&1
  [[ $? -eq 2 ]] || exit 1
  set -e
  echo "Assignment 1 checks passed."
}

run_assignment_2() {
  echo "=== Assignment 2 ==="
  cd "$ROOT_DIR/assignment-2-docker-cli"
  ./test.sh
  if command -v docker >/dev/null 2>&1; then
    docker build -t diagnostic-cli:verify .
    docker run --rm diagnostic-cli:verify help >/dev/null
    docker run --rm diagnostic-cli:verify system >/dev/null
    docker run --rm diagnostic-cli:verify disk >/dev/null
    set +e
    docker run --rm diagnostic-cli:verify invalid-command >/dev/null 2>&1
    rc=$?
    set -e
    [[ $rc -ne 0 ]]
    docker compose config >/dev/null
    docker image rm diagnostic-cli:verify >/dev/null 2>&1 || true
  else
    echo "Docker not found: Docker checks skipped."
  fi
  echo "Assignment 2 checks passed."
}

run_assignment_3() {
  echo "=== Assignment 3 ==="
  cd "$ROOT_DIR/assignment-3-ci-pipeline"
  ./scripts/lint.sh
  ./tests/test.sh
  grep -Eq 'push:' .github/workflows/ci.yml
  grep -Eq 'pull_request:' .github/workflows/ci.yml
  grep -Eq 'validate:' .github/workflows/ci.yml
  grep -A12 -E '^[[:space:]]*test:' .github/workflows/ci.yml | grep -Eq 'needs:[[:space:]]*validate'
  grep -A12 -E '^[[:space:]]*docker:' .github/workflows/ci.yml | grep -Eq 'needs:[[:space:]]*test'

  if command -v docker >/dev/null 2>&1; then
    docker build -t devops-ci-app:verify .
    docker run --rm devops-ci-app:verify help >/dev/null
    docker run --rm devops-ci-app:verify system-info >/dev/null
    set +e
    docker run --rm devops-ci-app:verify invalid-command >/dev/null 2>&1
    rc=$?
    set -e
    [[ $rc -ne 0 ]]
    docker image rm devops-ci-app:verify >/dev/null 2>&1 || true
  else
    echo "Docker not found: Docker checks skipped."
  fi
  echo "Assignment 3 checks passed."
}

run_assignment_1
run_assignment_2
run_assignment_3

echo "=== All available local checks passed ==="
