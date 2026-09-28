# Assignment 2 — Dockerized Diagnostic CLI

A lightweight Bash diagnostic CLI packaged as a Docker image.

## Commands

```bash
./app/diagnostic.sh help
./app/diagnostic.sh system
./app/diagnostic.sh disk
```

## Docker

```bash
docker build -t diagnostic-cli .
docker run --rm diagnostic-cli help
docker run --rm diagnostic-cli system
docker run --rm diagnostic-cli disk
```

## Docker Compose

```bash
docker compose run --rm diagnostic help
```

## Tests

```bash
./test.sh
```
