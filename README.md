# DevOps Diagnostics & CI Assessment

A three-part DevOps assessment covering Linux/Bash administration, networking checks, Dockerized CLI tooling, and GitHub Actions CI.

## Repository structure

- `assignment-1-linux-bash/` — system information, disk threshold, and network checks with logging.
- `assignment-2-docker-cli/` — Dockerized diagnostic CLI with Compose and a local test suite.
- `assignment-3-ci-pipeline/` — Bash CLI, validation/build/test scripts, Docker, Compose, and GitHub Actions CI.
- `verify-all.sh` — runs local non-Docker checks for all assignments and Docker checks when Docker is available.
- `setup-git-history.sh` — creates the five meaningful commits and feature branch required by the local Git checks using your own Git identity.
- `docs/STEP-BY-STEP.md` — setup, test, Git, and GitHub submission guide.

## Quick start

```bash
chmod +x verify-all.sh
./verify-all.sh
```

For full Docker verification, make sure Docker Desktop/Engine is running.

## Suggested repository name

`devops-diagnostics-ci-assessment`

## Suggested GitHub description

`Three-part DevOps assessment featuring Bash system/network diagnostics, Dockerized CLI tooling, automated tests, and a GitHub Actions CI pipeline.`
