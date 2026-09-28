# Assignment 3 — GitHub Actions, Docker & Bash

A Bash diagnostic application with validation, tests, Docker packaging, Compose, and a dependency-ordered GitHub Actions CI workflow.

## Commands

```bash
./app/app.sh help
./app/app.sh system-info
./app/app.sh check-port localhost 8080
```

## Local validation

```bash
./scripts/lint.sh
./tests/test.sh
```

## Docker

```bash
docker build -t devops-ci-app .
docker run --rm devops-ci-app help
docker run --rm devops-ci-app system-info
```

## CI stages

1. `validate` — validates Bash syntax and required files.
2. `test` — depends on `validate` and runs the application tests.
3. `docker` — depends on `test`, builds the image, and performs smoke tests.
