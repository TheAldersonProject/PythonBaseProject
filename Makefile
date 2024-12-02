# Makefile

# PYTHON
PYTHON = python3
PIP = $(PYTHON) -m pip
RUFF_PY_VERSION = py311
UV_PY_VERSION = --python 3.11.9
UV_ENV_ARGS = --allow-existing

# BLACK
BLACK_ARGS = --config ./pyproject.toml

# RUFF
RUFF = ruff --config ./pyproject.toml
RUFF_ARGS = --target-version $(RUFF_PY_VERSION)  -n

# PYRIGHT
PYRIGHT_ARGS = --project pyproject.toml --pythonversion 3.11.9 --stats

# PROJECT
SOURCE_DIR = ./app
SOURCE_PY_FILES = $(SOURCE_DIR)/**/*.py

TEST_DIR = ./tests
TEST_PY_FILES = $(TEST_DIR)/*.py

# Phony targets
.PHONY: help install format lint test clean build

# Default target
help:
	@echo "Available commands:"
	@echo "  make install    : Install dependencies"
	@echo "  make format     : Format code using Black and isort"
	@echo "  make lint       : Run linters"
	@echo "  make test       : Run tests"
	@echo "  make clean      : Remove build artifacts"
	@echo "  make build      : Runs all above to deploy"

# Install dependencies
install:
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	uv venv $(UV_PY_VERSION) $(UV_ENV_ARGS)
	uv sync
	uv run pre-commit install

# Format code
format:
	uv run black $(SOURCE_DIR) $(BLACK_ARGS)
	uv run $(RUFF) format $(SOURCE_DIR) $(RUFF_ARGS)

# Lint code
lint:
	uv run black --check $(SOURCE_DIR) $(BLACK_ARGS)
	uv run $(RUFF) check $(SOURCE_DIR) $(RUFF_ARGS) --fix
	uv run pyright $(SOURCE_DIR) $(PYRIGHT_ARGS)

# Run tests
test:
	uv run python3 -m pytest $(TEST_DIR)

# Clean build artifacts
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache

# run the phony as bellow
build:
	@echo clean project files
	make clean

	@echo install project assets
	make install

	@echo format project files
	make format

	@echo check project lint
	make lint

	@echo run tests
	make test
