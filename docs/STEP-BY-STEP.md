# Step-by-Step Setup, Fix, Test, and GitHub Submission Guide

## 1. Unzip and enter the project

```bash
unzip devops-diagnostics-ci-assessment.zip
cd devops-diagnostics-ci-assessment
```

## 2. Make every Bash script executable

```bash
chmod +x verify-all.sh
chmod +x assignment-1-linux-bash/*.sh
chmod +x assignment-2-docker-cli/app/diagnostic.sh assignment-2-docker-cli/test.sh
chmod +x assignment-3-ci-pipeline/app/app.sh assignment-3-ci-pipeline/scripts/*.sh assignment-3-ci-pipeline/tests/*.sh
```

Confirm:

```bash
find . -type f -name '*.sh' -exec ls -l {} \;
```

## 3. Test Assignment 1

```bash
cd assignment-1-linux-bash
bash -n system-info.sh disk-check.sh network-check.sh
./system-info.sh
./disk-check.sh 80 /
./network-check.sh localhost
```

Argument validation:

```bash
./disk-check.sh 0; echo $?
./disk-check.sh 101; echo $?
./disk-check.sh abc; echo $?
./network-check.sh; echo $?
./network-check.sh localhost 0; echo $?
./network-check.sh localhost 65536; echo $?
./network-check.sh localhost abc; echo $?
```

Invalid thresholds/ports should return exit code `2`. After running commands, confirm a log exists:

```bash
find logs -type f -maxdepth 1 -print
```

Return to root:

```bash
cd ..
```

## 4. Test Assignment 2

Start Docker Desktop first on macOS/Windows. Then:

```bash
cd assignment-2-docker-cli
./test.sh
docker build -t diagnostic-cli .
docker run --rm diagnostic-cli help
docker run --rm diagnostic-cli system
docker run --rm diagnostic-cli disk
docker run --rm diagnostic-cli invalid-command; echo $?
docker compose config
docker compose run --rm diagnostic help
cd ..
```

The first three container commands should succeed. `invalid-command` must return a non-zero exit code.

## 5. Test Assignment 3

```bash
cd assignment-3-ci-pipeline
./scripts/lint.sh
./tests/test.sh
docker build -t devops-ci-app .
docker run --rm devops-ci-app help
docker run --rm devops-ci-app system-info
docker run --rm devops-ci-app invalid-command; echo $?
docker compose config
cd ..
```

## 6. Run the combined verification script

From the repository root:

```bash
./verify-all.sh
```

## 7. Initialize Git and create the history the grader expects

The Assignment 1 grader requires at least five commits. The graders also look for a non-main local branch. Use meaningful commits instead of one large commit.

```bash
git init
git branch -M main

git add README.md .gitignore docs
git commit -m "docs: add assessment overview and setup guide"

git add assignment-1-linux-bash
git commit -m "feat: add Linux Bash and network diagnostics"

git add assignment-2-docker-cli
git commit -m "feat: add Dockerized diagnostic CLI"

git add assignment-3-ci-pipeline/app assignment-3-ci-pipeline/scripts assignment-3-ci-pipeline/tests
git commit -m "feat: add CI diagnostic app and test scripts"

git add assignment-3-ci-pipeline/Dockerfile assignment-3-ci-pipeline/compose.yaml assignment-3-ci-pipeline/.dockerignore assignment-3-ci-pipeline/.github verify-all.sh assignment-3-ci-pipeline/README.md
git commit -m "ci: add Docker packaging and GitHub Actions pipeline"
```

Confirm at least five commits:

```bash
git log --oneline --decorate -5
```

Create a feature branch so the local grader can detect one:

```bash
git branch feature/assessment-validation
```

Confirm it exists:

```bash
git branch
```

## 8. Create the GitHub repository

Recommended repository name:

```text
devops-diagnostics-ci-assessment
```

Recommended GitHub description:

```text
Three-part DevOps assessment featuring Bash system/network diagnostics, Dockerized CLI tooling, automated tests, and a GitHub Actions CI pipeline.
```

On GitHub, create an empty repository with that name. Do not initialize it with a README because this project already has one.

## 9. Connect and push to GitHub

Replace `YOUR_GITHUB_USERNAME` with your username:

```bash
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/devops-diagnostics-ci-assessment.git
git push -u origin main
git push origin feature/assessment-validation
```

## 10. Verify GitHub Actions

Open the repository on GitHub and select **Actions**. The workflow should run `validate`, then `test`, then `docker`. All three should be green.

If the workflow does not start, confirm `.github/workflows/ci.yml` exists on the `main` branch.

## 11. If you have the supplied local grader scripts

Run each grader from inside the corresponding assignment directory, because the grader checks relative file paths.

Example:

```bash
cd assignment-1-linux-bash
bash /path/to/assignment1-grader.sh

cd ../assignment-2-docker-cli
bash /path/to/assignment2-grader.sh

cd ../assignment-3-ci-pipeline
bash /path/to/assignment3-grader.sh
```

Do not put the three assignment file sets into one flat directory because Assignments 2 and 3 both require files with the same names such as `Dockerfile`, `compose.yaml`, and `README.md`.

## 12. Final checks before submission

```bash
git status
git log --oneline --all --decorate
git branch -a
```

Expected result: clean working tree, at least five commits, `main` plus a feature branch, and a successful GitHub Actions run.
