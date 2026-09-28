# DevOps Diagnostics CI Assessment

A three-part DevOps assessment demonstrating practical skills in **Linux administration, Bash scripting, networking, Docker, automated testing, Git, and GitHub Actions CI/CD**.

The project contains three independent assignments that progress from local system diagnostics to containerization and finally to automated CI validation.

---

## Project Overview

This repository demonstrates hands-on DevOps capabilities across:

* Linux system diagnostics
* Bash scripting
* Argument validation
* Network connectivity checks
* Disk usage monitoring
* Logging
* Docker image creation
* Docker Compose
* CLI application development
* Automated Bash testing
* Git version control
* Feature branch workflows
* GitHub Actions
* CI job dependencies
* Docker smoke testing

The project is structured so that each assignment can be executed and tested independently.

---

## Repository Structure

```text
devops-diagnostics-ci-assessment/
│
├── assignment-1-linux-bash/
│   ├── README.md
│   ├── system-info.sh
│   ├── disk-check.sh
│   ├── network-check.sh
│   └── logs/
│       └── .gitkeep
│
├── assignment-2-docker-cli/
│   ├── app/
│   │   └── diagnostic.sh
│   ├── Dockerfile
│   ├── compose.yaml
│   ├── .dockerignore
│   ├── test.sh
│   └── README.md
│
├── assignment-3-ci-pipeline/
│   ├── app/
│   │   └── app.sh
│   ├── scripts/
│   │   ├── lint.sh
│   │   └── build.sh
│   ├── tests/
│   │   └── test.sh
│   ├── .github/
│   │   └── workflows/
│   │       └── ci.yml
│   ├── Dockerfile
│   ├── compose.yaml
│   ├── .dockerignore
│   └── README.md
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── docs/
│   └── STEP-BY-STEP.md
│
├── .gitignore
├── setup-git-history.sh
├── verify-all.sh
└── README.md
```

---

# Assignment 1 — Linux, Bash, Networking & Git

The first assignment focuses on Linux administration and Bash scripting.

It includes three command-line utilities.

## `system-info.sh`

Displays useful system information including:

* Hostname
* Current user
* Kernel information
* System uptime
* Operating system information
* CPU details
* Memory information

### Run

```bash
cd assignment-1-linux-bash

./system-info.sh
```

---

## `disk-check.sh`

Checks disk utilization against a configurable threshold.

### Syntax

```bash
./disk-check.sh <threshold> [path]
```

### Example

```bash
./disk-check.sh 80 /
```

The script validates the threshold before executing.

Valid thresholds must be between:

```text
1 - 100
```

Invalid inputs return exit code:

```text
2
```

Examples:

```bash
./disk-check.sh 0
./disk-check.sh 101
./disk-check.sh abc
```

Check the exit code with:

```bash
echo $?
```

---

## `network-check.sh`

Tests network connectivity to a specified host.

### Syntax

```bash
./network-check.sh <host> [port]
```

Example:

```bash
./network-check.sh localhost
```

Or with a port:

```bash
./network-check.sh localhost 80
```

The script validates port numbers and rejects:

```text
0
65536
non-numeric values
```

Valid TCP port numbers must be between:

```text
1 - 65535
```

---

## Logging

Diagnostic activity is written to the:

```text
assignment-1-linux-bash/logs/
```

directory.

To view generated logs:

```bash
find assignment-1-linux-bash/logs -type f -print
```

---

# Assignment 2 — Dockerized Diagnostic CLI

The second assignment converts system diagnostic functionality into a containerized command-line application.

The application supports multiple commands.

## Available Commands

```bash
help
system
disk
```

---

## Run Locally

Move into the assignment directory:

```bash
cd assignment-2-docker-cli
```

Run:

```bash
./app/diagnostic.sh help
```

System diagnostics:

```bash
./app/diagnostic.sh system
```

Disk diagnostics:

```bash
./app/diagnostic.sh disk
```

---

## Run Tests

```bash
./test.sh
```

The test suite validates:

* Help command
* System command
* Disk command
* Invalid command handling
* Expected exit codes

---

## Build Docker Image

Docker Desktop or Docker Engine must be running.

```bash
docker build -t diagnostic-cli .
```

---

## Run Docker Commands

Help:

```bash
docker run --rm diagnostic-cli help
```

System information:

```bash
docker run --rm diagnostic-cli system
```

Disk information:

```bash
docker run --rm diagnostic-cli disk
```

Invalid commands intentionally return a non-zero exit code:

```bash
docker run --rm diagnostic-cli invalid-command
echo $?
```

---

## Docker Compose

Validate the configuration:

```bash
docker compose config
```

Run the CLI:

```bash
docker compose run --rm diagnostic help
```

---

# Assignment 3 — GitHub Actions, Docker & Bash

The third assignment introduces automated validation and CI/CD practices.

It contains:

* Bash application
* Lint script
* Build script
* Automated tests
* Docker packaging
* Docker Compose configuration
* GitHub Actions pipeline

---

## Application Commands

Move into the directory:

```bash
cd assignment-3-ci-pipeline
```

Display help:

```bash
./app/app.sh help
```

Display system information:

```bash
./app/app.sh system-info
```

Check a network port:

```bash
./app/app.sh check-port localhost 80
```

---

## Input Validation

Invalid ports are rejected.

Examples:

```bash
./app/app.sh check-port localhost abc
./app/app.sh check-port localhost 0
./app/app.sh check-port localhost 65536
```

Invalid user input returns exit code:

```text
2
```

---

## Bash Linting

Run:

```bash
./scripts/lint.sh
```

The lint process validates Bash syntax across the project scripts.

---

## Automated Tests

Run:

```bash
./tests/test.sh
```

The tests validate application commands, input handling, and expected exit codes.

---

# Docker

Build the Assignment 3 image:

```bash
cd assignment-3-ci-pipeline

docker build -t devops-ci-app .
```

Run:

```bash
docker run --rm devops-ci-app help
```

System diagnostics:

```bash
docker run --rm devops-ci-app system-info
```

Invalid command test:

```bash
docker run --rm devops-ci-app invalid-command

echo $?
```

The invalid command should return a non-zero status.

---

# Docker Compose

Validate:

```bash
docker compose config
```

Run:

```bash
docker compose run --rm app help
```

---

# GitHub Actions CI Pipeline

The repository includes a GitHub Actions workflow that automatically validates the project when changes are pushed or submitted through a pull request.

The CI pipeline follows this dependency chain:

```text
validate
   ↓
test
   ↓
docker
```

## Validate Job

The `validate` job:

* Checks out the repository
* Ensures scripts are executable
* Validates Bash syntax
* Runs lint checks

---

## Test Job

The `test` job runs only after validation succeeds.

```yaml
needs: validate
```

It executes the automated test suite.

---

## Docker Job

The Docker job runs only after the test job succeeds.

```yaml
needs: test
```

It:

* Builds the Docker image
* Runs the help command
* Runs system diagnostics
* Verifies invalid commands fail correctly

This prevents Docker packaging from succeeding when earlier validation or application tests fail.

---

# Running the Complete Assessment

From the repository root:

```bash
chmod +x verify-all.sh

./verify-all.sh
```

This executes the available project-level verification checks.

---

# Prerequisites

The following tools are recommended:

* Git
* Bash
* Docker
* Docker Compose
* macOS or Linux terminal

Verify installations with:

```bash
git --version
bash --version
docker --version
docker compose version
```

---

# Installation

Clone the repository:

```bash
git clone https://github.com/poundsmichaelscode/devops-diagnostics-ci-assessment.git
```

Enter the project:

```bash
cd devops-diagnostics-ci-assessment
```

Make scripts executable if required:

```bash
chmod +x verify-all.sh
chmod +x setup-git-history.sh

chmod +x assignment-1-linux-bash/*.sh

chmod +x assignment-2-docker-cli/app/diagnostic.sh
chmod +x assignment-2-docker-cli/test.sh

chmod +x assignment-3-ci-pipeline/app/app.sh
chmod +x assignment-3-ci-pipeline/scripts/*.sh
chmod +x assignment-3-ci-pipeline/tests/*.sh
```

---

# Git Workflow

The repository uses a structured Git history with multiple meaningful commits covering:

1. Project documentation and initial setup
2. Linux/Bash diagnostic utilities
3. Dockerized diagnostic CLI
4. CI application and test scripts
5. Docker packaging and GitHub Actions configuration

The repository also contains a non-main development branch:

```text
feature/assessment-validation
```

View the commit history:

```bash
git log --oneline --decorate --all
```

View branches:

```bash
git branch -a
```

---

# Error Handling

The Bash applications use meaningful exit codes.

| Exit Code      | Meaning                                  |
| -------------- | ---------------------------------------- |
| `0`            | Successful execution                     |
| `1`            | Diagnostic/check condition not satisfied |
| `2`            | Invalid argument or usage error          |
| Other non-zero | Command or runtime failure               |

This makes the scripts suitable for automation and CI environments.

---

# Security & Repository Hygiene

The project follows basic DevOps repository practices including:

* No hard-coded credentials
* No secrets committed to Git
* `.gitignore` configuration
* `.dockerignore` configuration
* Small Docker build contexts
* Input validation
* Non-zero exit codes for failures
* Automated CI testing
* Reproducible Docker builds

---

# Assessment Skills Demonstrated

### Linux Administration

* System information inspection
* Disk monitoring
* Process-independent diagnostics
* Network connectivity checks

### Bash

* Functions
* Conditionals
* Argument parsing
* Exit codes
* Input validation
* Logging
* Shell syntax validation

### Networking

* Host connectivity checks
* TCP port validation
* Localhost testing

### Docker

* Dockerfiles
* Image builds
* Container execution
* ENTRYPOINT/CMD behavior
* Docker Compose
* `.dockerignore`
* Container smoke tests

### Git

* Structured commit history
* Branch management
* Feature branch workflow
* Remote repository management

### CI/CD

* GitHub Actions
* Push triggers
* Pull request triggers
* Job dependencies
* Automated validation
* Automated testing
* Docker build verification

---

# Verification Checklist

Before submission:

```bash
./verify-all.sh
```

Check Git:

```bash
git status
```

Expected result:

```text
nothing to commit, working tree clean
```

Check commits:

```bash
git log --oneline --decorate -6
```

Check branches:

```bash
git branch -a
```

Validate Docker:

```bash
cd assignment-2-docker-cli
docker build -t diagnostic-cli .
docker compose config

cd ../assignment-3-ci-pipeline
docker build -t devops-ci-app .
docker compose config
```

Finally, verify the GitHub Actions workflow is passing from the repository's **Actions** tab.

---

# Repository

**Repository Name**

```text
devops-diagnostics-ci-assessment
```

**GitHub**

```text
https://github.com/poundsmichaelscode/devops-diagnostics-ci-assessment
```

---

# Author

**Olayenikan Michael**

DevOps Engineer | Cloud Engineer | Linux Administrator | Backend Developer

Lagos, Nigeria

---

## Conclusion

This assessment demonstrates a practical DevOps workflow beginning with Linux and Bash system administration, progressing through Docker containerization, and ending with automated validation through GitHub Actions.

The implementation emphasizes reliability, input validation, meaningful exit codes, reproducibility, testing, containerization, and CI automation—core practices used in modern DevOps environments.

