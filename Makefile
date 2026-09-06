PYTHON ?= python

.PHONY: install lint test build ci clean

install:
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements.txt

lint:
	$(PYTHON) -m flake8 appname tests

test:
	$(PYTHON) -m pytest -v --cov=appname --cov-report=term-missing tests/

build:
	$(PYTHON) -m compileall appname

ci: lint test build

clean:
	$(PYTHON) -m pip cache purge