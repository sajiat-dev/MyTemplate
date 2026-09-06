SYSTEM_PYTHON ?= python
VENV := .venv
ARTIFACTS := artifacts

# Use the correct Python executable for Windows or Unix/Linux.
ifeq ($(OS),Windows_NT)
    PYTHON := $(VENV)/Scripts/python.exe
else
    PYTHON := $(VENV)/bin/python
endif

.PHONY: install prepare test lint security build ui-test ci clean

# Create the virtual environment and install all dependencies.
install:
	$(SYSTEM_PYTHON) -m venv $(VENV)
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements-dev.txt

#prepare the artifacts directories for test results and coverage reports.
prepare:
	$(SYSTEM_PYTHON) -c "import os; os.makedirs('$(ARTIFACTS)/junit', exist_ok=True); os.makedirs('$(ARTIFACTS)/coverage', exist_ok=True); os.makedirs('$(ARTIFACTS)/playwright', exist_ok=True)"

# Run backend tests and save the artifacts for CI reporting.
test: prepare
	$(PYTHON) -m pytest -v tests/ --ignore=tests/test_ui.py \
		--junitxml=$(ARTIFACTS)/junit/pytest.xml \
		--cov=appname \
		--cov-report=xml:$(ARTIFACTS)/coverage/coverage.xml \
		--cov-report=html:$(ARTIFACTS)/coverage/html

# Run static analysis and linting.
lint:
	$(PYTHON) -m ruff check .

# Run security checks.
security:
	$(PYTHON) -m bandit -r appname

# Validate Python source compilation.
build:
	$(PYTHON) -m compileall appname

ui-test: prepare
	$(PYTHON) scripts/run_ui_tests.py

# Run the complete CI validation.
ci: lint security test ui-test build

# Remove generated Python/test files and the virtual environment.
clean:
	$(SYSTEM_PYTHON) -c "import shutil; shutil.rmtree('.venv', ignore_errors=True); shutil.rmtree('.pytest_cache', ignore_errors=True); shutil.rmtree('.ruff_cache', ignore_errors=True); shutil.rmtree('.coverage', ignore_errors=True)"