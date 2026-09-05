PYTHON := python3
VENV := .venv
PIP := $(VENV)/bin/pip
PYTEST := $(VENV)/bin/pytest

.PHONY: install test lint build clean ci

install:
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	$(PIP) install -r requirements-dev.txt

test:
	$(PYTEST) -v

lint:
	$(VENV)/bin/flake8 .

build:
	$(PIP) install -r requirements.txt

clean:
	rm -rf $(VENV)
	rm -rf .pytest_cache
	rm -rf __pycache__
	rm -rf .coverage

ci: lint test build
