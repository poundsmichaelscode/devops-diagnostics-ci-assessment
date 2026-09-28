# Assignment 1 — Linux, Bash, Networking & Git

This assignment provides three Bash utilities:

- `system-info.sh` — displays hostname, current user, kernel, and uptime.
- `disk-check.sh` — validates a percentage threshold and checks disk usage for a path.
- `network-check.sh` — checks host reachability/resolution and optionally a TCP port.

All commands create timestamped entries under `logs/`.

## Usage

```bash
./system-info.sh
./disk-check.sh 80 /
./network-check.sh localhost
./network-check.sh localhost 8080
```

## Exit codes

- `0` — successful/healthy result.
- `1` — valid check completed but warning/unreachable condition detected.
- `2` — invalid usage or invalid argument.
