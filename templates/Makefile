# Makefile

# Variables
POETRY = poetry
PYTHON = $(POETRY) run python
SOURCE_DIR = src
TEST_DIR = tests
PYLINT = $(POETRY) run pylint
PYLINT_ARGS = $(SOURCE_DIR) --output-format=text
MYPY_ARGS = --config-file pyproject.toml
GIT_REPO_URL = GIT_REPO_URL
GIT_INITIAL_BRANCH = GIT_INITIAL_BRANCH

# Phony targets
.PHONY: help setup install format lint test clean build check git-setup

# Default target
help:
	@echo "Available commands:"
	@echo "  make setup      : Set up the project (install dependencies)"
	@echo "  make install    : Install or update dependencies"
	@echo "  make format     : Format code using Black and isort"
	@echo "  make lint       : Run linters"
	@echo "  make test       : Run tests"
	@echo "  make clean      : Remove build artifacts"
	@echo "  make build      : Run all checks and tests"
	@echo "  make check      : Check code quality"
	@echo "  make git-setup  : Initialize Git repository (if not already done)"

# Set up the project
setup: install git-setup

# Install or update dependencies
install:
	$(POETRY) install
	$(POETRY) run mypy $(MYPY_ARGS) --install-types --non-interactive $(SOURCE_DIR)

# Format code
format:
	$(POETRY) run black $(SOURCE_DIR) $(TEST_DIR)
	$(POETRY) run isort $(SOURCE_DIR) $(TEST_DIR)

# Lint code
lint:
	$(POETRY) run mypy $(MYPY_ARGS) $(SOURCE_DIR)
	$(POETRY) run flake8 $(SOURCE_DIR) $(TEST_DIR)
	$(PYLINT) $(PYLINT_ARGS)
	$(PYLINT) $(TEST_DIR) $(PYLINT_ARGS)

# Run tests
test:
	$(POETRY) run pytest $(TEST_DIR)

# Clean build artifacts
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf dist

# Run the phony as below
build: clean install format lint test

# Check code quality
check: format lint test

# Set up Git repository
git-setup:
	@if [ ! -d .git ]; then \
		git init; \
		git branch -M $(GIT_INITIAL_BRANCH); \
		git remote add origin $(GIT_REPO_URL); \
		echo "Git repository initialized with remote: $(GIT_REPO_URL)"; \
		echo "Initial branch set to: $(GIT_INITIAL_BRANCH)"; \
	else \
		echo "Git repository already initialized."; \
	fi