# MyTemplate

A Flask application prepared as part of the assessment. The
repository was adapted from the provided Ignite reference application
and updated to use the **MyTemplate** application name/branding where
appropriate.

This README documents the implementation completed for the assessment,
including application changes, the repeatable Makefile-based build
process, automated testing, static analysis, security scanning,
coverage, GitHub Actions CI, and generated build artifacts.

------------------------------------------------------------------------

## Table of Contents

-   [Assessment Requirements](#assessment-requirements)
-   [Project Structure](#project-structure)
-   [Prerequisites](#prerequisites)
-   [Local Setup](#local-setup)
-   [Running the Application](#running-the-application)
-   [Build and CI Process](#build-and-ci-process)
-   [Makefile Targets](#makefile-targets)
-   [Testing](#testing)
-   [Static Analysis](#static-analysis)
-   [Security Scanning](#security-scanning)
-   [Build Validation](#build-validation)
-   [Coverage](#coverage)
-   [GitHub Actions](#github-actions)
-   [Build Artifacts](#build-artifacts)
-   [Assessment Test Coverage](#assessment-test-coverage)
-   [Troubleshooting](#troubleshooting)
-   [Submission Checklist](#submission-checklist)

------------------------------------------------------------------------

## Assessment Requirements

The assessment requires the following:

### 1. Application Change

-   Rename the application from **Ignite** to **MyTemplate** throughout
    the codebase and UI where appropriate.
-   Update application branding/user-facing references such as:
    -   Page titles
    -   Application headers
    -   README/documentation
    -   Metadata
    -   User-facing labels
    -   Other visible branding references

### 2. Build Process

Create a repeatable build process using:

-   Makefile
-   GitHub Actions workflow

The workflow should run on push and/or pull request events.

The same build/check process should be usable locally and in CI.

For the assessment, the CI process can be simulated locally by running:

``` bash
make ci
```

No production deployment is required.

### 3. Required Tools

The build process uses:

  Tool                Purpose
  ------------------- -----------------------------
  pytest              Backend testing
  pytest-playwright   UI/browser testing
  Ruff                Static analysis and linting
  Bandit              Security scanning
  pytest-cov          Test coverage reporting
  GitHub Actions      CI execution

### 4. Testing Expectations

The implementation includes:

-   Backend tests using pytest
-   At least one meaningful UI test using Playwright
-   Small, focused tests representing real user/application flows

### 5. Reports and Artifacts

The build produces:

-   Unit test report in JUnit XML format
-   Coverage report in XML format
-   Coverage HTML report
-   Ruff static-analysis report in JSON format
-   Bandit security report in JSON format
-   Playwright test report in JUnit XML format
-   Optional Playwright failure evidence when produced by the configured
    test runner

### 6. Repository Submission

The repository contains:

-   Application changes
-   Build script
-   Makefile
-   GitHub Actions workflow
-   Tests
-   Development requirements
-   Configuration required by the checks
-   Documentation explaining how to run the application and checks

------------------------------------------------------------------------

# Project Structure

The important assessment-related files/directories are organized
approximately as follows:

``` text
MyTemplate/
│
├── appname/
│   ├── api/
│   ├── controllers/
│   ├── models/
│   ├── services/
│   ├── templates/
│   └── ...
│
├── tests/
│   ├── conftest.py
│   ├── test_config.py
│   ├── test_urls.py
│   ├── test_ui.py
│   └── ...
│
├── artifacts/
│   ├── coverage/
│   │   ├── coverage.xml
│   │   └── html/
│   ├── junit/
│   │   ├── pytest.xml
│   │   └── playwright.xml
│   ├── playwright/
│   ├── bandit.json
│   └── ruff.json
│
├── .github/
│   └── workflows/
│       └── ...
│
├── .venv/
├── .coveragerc
├── Makefile
├── manage.py
├── requirements-dev.txt
├── .gitignore
└── README.md
```

The `.venv` directory and generated build artifacts are intended for
local/CI use and should not be committed as source code.

------------------------------------------------------------------------

# Prerequisites

Install the following before running the project locally:

-   Python
-   Git
-   GNU Make

On Windows, Make is not included with a standard Python installation. A
Make-compatible environment such as Git Bash, MSYS2, or another Windows
Make installation can be used.

The project itself uses a Python virtual environment located at:

``` text
.venv/
```

The Makefile automatically selects the appropriate Python executable for
Windows or Unix/Linux environments.

------------------------------------------------------------------------

# Local Setup

Clone the repository and enter the project directory.

Create/install the development environment using:

``` bash
make install
```

The `install` target:

1.  Creates `.venv`
2.  Upgrades pip
3.  Installs dependencies from:

``` text
requirements-dev.txt
```

If the virtual environment already exists, the command can be run again
to ensure the development dependencies are installed.

------------------------------------------------------------------------

# Running the Application

The Flask application uses the application factory:

``` python
create_app(...)
```

The development configuration is selected by default through:

``` text
APPNAME_ENV=dev
```

The project includes `manage.py` for Flask application management.

On Windows PowerShell, the environment can be selected with:

``` powershell
$env:APPNAME_ENV="dev"
```

The development server can then be started through the Flask management
command.

The application should be running before executing Playwright tests
manually unless the UI test target starts the required server itself.

------------------------------------------------------------------------

# Build and CI Process

The central entry point for validation is:

``` bash
make ci
```

The CI target runs the following checks:

``` text
lint
  ↓
security
  ↓
test
  ↓
build
```

This gives the project a single repeatable command that can be used both
locally and from GitHub Actions.

The important design principle is that the **Makefile owns the actual
validation commands**, while GitHub Actions invokes the same process.
This prevents local and CI environments from having different test
commands.

------------------------------------------------------------------------

# Makefile Targets

The Makefile provides the following targets.

## `make install`

Creates the Python virtual environment and installs development
dependencies.

``` bash
make install
```

------------------------------------------------------------------------

## `make prepare`

Creates the directories used for generated CI/test artifacts.

``` bash
make prepare
```

The generated artifact directories include:

``` text
artifacts/junit/
artifacts/coverage/
artifacts/playwright/
```

------------------------------------------------------------------------

## `make test`

Runs the Python test suite with pytest and generates JUnit and coverage
reports.

``` bash
make test
```

The test command generates:

``` text
artifacts/junit/pytest.xml
artifacts/coverage/coverage.xml
artifacts/coverage/html/
```

The Playwright test report is also produced when the UI test
configuration is included in the pytest run:

``` text
artifacts/junit/playwright.xml
```

------------------------------------------------------------------------

## `make lint`

Runs Ruff against the project:

``` bash
make lint
```

The result is written as a machine-readable JSON report:

``` text
artifacts/ruff.json
```

A successful run returns a zero exit status.

------------------------------------------------------------------------

## `make security`

Runs Bandit against the application source:

``` bash
make security
```

The result is written as:

``` text
artifacts/bandit.json
```

Security findings cause the command to return a non-zero exit status so
that CI can detect the failure.

------------------------------------------------------------------------

## `make build`

Performs Python source compilation validation:

``` bash
make build
```

This validates that the Python source files can be compiled
successfully.

------------------------------------------------------------------------

## `make ci`

Runs the complete CI validation:

``` bash
make ci
```

This is the primary command to run before committing/pushing assessment
changes.

------------------------------------------------------------------------

## `make clean`

Removes generated local environment/cache files such as:

-   `.venv`
-   pytest cache
-   Ruff cache
-   local coverage data

``` bash
make clean
```

Generated reports under `artifacts/` can also be cleaned separately if
required.

------------------------------------------------------------------------

# Testing

## Backend Tests

Backend/application tests are implemented with pytest.

Run:

``` bash
make test
```

The test suite includes application configuration and route-level tests.

Examples include validation that:

``` text
GET /
GET /login
GET /auth/logout
GET /signup
GET /dashboard/
```

return the expected status codes.

The tests use the Flask application factory and the test configuration.

------------------------------------------------------------------------

# UI Testing

UI testing is implemented with:

``` text
pytest-playwright
```

The UI test exercises a real browser flow rather than only testing
Python functions.

The assessment includes a meaningful home-page UI test that verifies
that the expected login-related UI content is present.

Playwright uses Chromium in the CI environment.

For GitHub Actions, the workflow installs the required Playwright
browser/dependencies before executing the test suite.

The UI test produces a JUnit report:

``` text
artifacts/junit/playwright.xml
```

When configured to retain failure evidence, Playwright can additionally
produce screenshots/traces under:

``` text
artifacts/playwright/
```

------------------------------------------------------------------------

# Static Analysis

Ruff is used for linting and static analysis.

Run:

``` bash
make lint
```

The machine-readable result is stored in:

``` text
artifacts/ruff.json
```

A clean result is represented by an empty JSON array:

``` json
[]
```

This makes the report suitable for automated CI processing while still
being easy to inspect.

------------------------------------------------------------------------

# Security Scanning

Bandit is used to scan the Python application source for common security
issues.

Run:

``` bash
make security
```

The report is generated as:

``` text
artifacts/bandit.json
```

During development, a Bandit finding was identified in the
token/security service because MD5 was being used to derive a short
identifier.

The implementation was adjusted so that the security scan passes
successfully while preserving the application's required token behavior.

The final expected result is:

``` text
Bandit scan: PASS
```

------------------------------------------------------------------------

# Build Validation

The build stage validates Python source compilation:

``` bash
make build
```

The command uses Python's compilation facilities to catch
syntax/compilation problems before the CI process is considered
successful.

------------------------------------------------------------------------

# Coverage

Coverage is generated using:

``` text
pytest-cov
```

The project uses `.coveragerc` to configure coverage collection.

Coverage output includes:

``` text
artifacts/coverage/coverage.xml
artifacts/coverage/html/
```

The XML report is suitable for CI/reporting integrations.

The HTML report provides a human-readable view of covered and uncovered
source lines.

Generated coverage reports are build artifacts and should not be
committed to the source repository.

------------------------------------------------------------------------

# GitHub Actions

The repository contains a GitHub Actions workflow under:

``` text
.github/workflows/
```

The workflow is designed to run the same validation process used
locally.

The workflow performs the following high-level sequence:

``` text
Checkout repository
        ↓
Set up Python
        ↓
Install dependencies
        ↓
Install Playwright browser/dependencies
        ↓
Run make ci
        ↓
Upload artifacts
```

The workflow is configured for repository changes such as:

``` text
push
pull_request
```

The important part of the implementation is that GitHub Actions does not
duplicate the individual test/lint/security commands. Instead, it
invokes:

``` bash
make ci
```

This keeps local and CI validation consistent.

------------------------------------------------------------------------

# GitHub Actions Artifacts

After CI completes, the generated `artifacts/` directory is uploaded
using GitHub Actions artifact storage.

The artifact contains the assessment reports.

Expected structure:

``` text
build-artifacts/
│
├── bandit.json
├── ruff.json
│
├── coverage/
│   ├── coverage.xml
│   └── html/
│       └── ...
│
├── junit/
│   ├── pytest.xml
│   └── playwright.xml
│
└── playwright/
    └── ...
```

The `playwright/` directory may contain files when the configured
Playwright runner produces screenshots/traces or other browser evidence.
It may be empty for a completely successful run.

The artifact upload step uses `if: always()` so reports are preserved
even when an earlier CI step fails. This makes failed CI runs easier to
diagnose.

------------------------------------------------------------------------

# Assessment Test Coverage

The tests were intentionally kept small and meaningful rather than
attempting to build an exhaustive test suite.

The current assessment-oriented checks cover:

### Application configuration

-   Development configuration
-   Test configuration
-   Cache configuration
-   Test application initialization

### Routes

-   Home page
-   Login page
-   Logout behavior
-   Signup page
-   Protected dashboard behavior

### UI

-   Home page loads in Chromium
-   Expected login-related content is present

### Build quality

-   Ruff linting
-   Bandit security scanning
-   Python compilation
-   pytest execution
-   Playwright browser execution
-   Coverage generation

------------------------------------------------------------------------

# Troubleshooting

## `make` is not recognized on Windows

If PowerShell reports:

``` text
make : The term 'make' is not recognized...
```

install/use a Make-compatible environment such as Git Bash/MSYS2 and
ensure `make` is available on `PATH`.

The Makefile itself supports the Windows Python virtual environment
layout:

``` text
.venv/Scripts/python.exe
```

and Unix/Linux layout:

``` text
.venv/bin/python
```

------------------------------------------------------------------------

## Playwright cannot connect to `127.0.0.1:5000`

The browser test requires the Flask application to be available.

If running the UI test manually, ensure the application server is
running on the expected host/port.

The CI setup is responsible for preparing the environment required by
the UI tests.

------------------------------------------------------------------------

## Playwright browser executable is missing

If Playwright reports that Chromium is not installed, install the
browser:

``` bash
python -m playwright install chromium
```

For GitHub Actions/Linux, the workflow installs the required browser
dependencies as part of CI setup.

------------------------------------------------------------------------

## SQLite cannot open the database

The test configuration uses a test database. The required
temporary/storage directories must exist before Flask extensions
initialize.

The test configuration creates the required temporary storage directory
during application/test setup so that CI runners, which start with a
clean filesystem, can initialize the application successfully.

------------------------------------------------------------------------

## Ruff fails

Run:

``` bash
make lint
```

Then inspect:

``` text
artifacts/ruff.json
```

Fix the reported source issues and rerun:

``` bash
make lint
```

------------------------------------------------------------------------

## Bandit fails

Run:

``` bash
make security
```

Then inspect:

``` text
artifacts/bandit.json
```

Security findings should be addressed rather than ignored unless there
is a documented and justified reason for an exception.

------------------------------------------------------------------------

# Recommended Development Workflow

Before committing changes, run:

``` bash
make ci
```

If successful:

``` bash
git status
git add .
git commit -m "Describe the change"
git push
```

GitHub Actions will then execute the same CI validation and upload the
generated reports.

Recommended workflow:

``` text
Make code change
      ↓
Run make ci locally
      ↓
Review artifacts/
      ↓
Commit
      ↓
Push
      ↓
GitHub Actions
      ↓
Review CI result
      ↓
Review build-artifacts
```

------------------------------------------------------------------------

# Checklist

-   [x] Application renamed/updated to MyTemplate where appropriate
-   [x] Makefile added
-   [x] Development requirements documented in `requirements-dev.txt`
-   [x] Repeatable local CI command available with `make ci`
-   [x] Backend pytest tests passing
-   [x] Playwright UI test passing
-   [x] Ruff linting passing
-   [x] Bandit security scan passing
-   [x] Python build/compile validation passing
-   [x] JUnit XML report generated
-   [x] Coverage XML generated
-   [x] Coverage HTML generated
-   [x] Ruff JSON report generated
-   [x] Bandit JSON report generated
-   [x] Playwright JUnit report generated
-   [x] Generated artifacts excluded from source control as appropriate
-   [x] GitHub Actions workflow added
-   [x] GitHub Actions successfully runs the CI process
-   [x] GitHub Actions uploads build artifacts
-   [x] README documents local setup and validation commands

------------------------------------------------------------------------

# Final CI Command

The single command that represents the complete assessment validation
is:

``` bash
make ci
```

A successful run means the project has passed:

``` text
Ruff
  ↓
Bandit
  ↓
pytest + coverage + Playwright
  ↓
Python compilation
```

The generated reports are available under:

``` text
artifacts/
```

and the same artifacts are uploaded by GitHub Actions for review.
