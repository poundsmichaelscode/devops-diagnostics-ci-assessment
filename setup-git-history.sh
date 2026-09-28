#!/usr/bin/env bash
set -euo pipefail

if [[ -d .git ]]; then
  echo "Error: this directory is already a Git repository." >&2
  exit 2
fi

if ! git config user.name >/dev/null 2>&1 || ! git config user.email >/dev/null 2>&1; then
  echo "Configure your Git identity first:" >&2
  echo '  git config --global user.name "Your Name"' >&2
  echo '  git config --global user.email "you@example.com"' >&2
  exit 2
fi

git init
git branch -M main

git add README.md .gitignore docs setup-git-history.sh
git commit -m "docs: add assessment overview and setup guide"

git add assignment-1-linux-bash
git commit -m "feat: add Linux Bash and network diagnostics"

git add assignment-2-docker-cli
git commit -m "feat: add Dockerized diagnostic CLI"

git add assignment-3-ci-pipeline/app assignment-3-ci-pipeline/scripts assignment-3-ci-pipeline/tests
git commit -m "feat: add CI diagnostic app and test scripts"

git add assignment-3-ci-pipeline/Dockerfile assignment-3-ci-pipeline/compose.yaml assignment-3-ci-pipeline/.dockerignore assignment-3-ci-pipeline/.github assignment-3-ci-pipeline/README.md verify-all.sh
git commit -m "ci: add Docker packaging and GitHub Actions pipeline"

git branch feature/assessment-validation

echo
echo "Git history created successfully."
git log --oneline --decorate -5
echo
echo "Local branches:"
git branch
