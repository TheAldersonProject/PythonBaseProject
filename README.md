# Python Base Project

## Overview

A standardized Python project template implementing industry best practices for code quality, type safety, and development workflows. This template provides a structured environment with automated build processes and pre-configured development tools.

## Technical Specifications

### Core Requirements

- Python 3.11.9
- UV Package Manager
- Make (for build automation)

### Quality Assurance Tools

- **Code Formatting & Linting**
  - Black: Code formatting
  - Ruff: Comprehensive linting and formatting
  - Pyright: Static type checking
  - Pre-commit hooks

### Repository Structure

repository/
├── src/                    # Source code directory
├── tests/                  # Test suite
├── .env                    # Environment configuration
├── .gitignore             # Git exclusion patterns
├── .pre-commit-config.yaml # Pre-commit hook configuration
├── Makefile               # Build automation
├── pyproject.toml         # Project and tool configuration
└── README.md              # Project documentation


## Build System

The project uses Make for build automation and development workflows.

### Run `make help` to see the available commands

```bash
    make help
  ```

### Build Configuration

#### Python Settings
* Python Version: 3.11.9

#### Tool Arguments
* Black: Configured via pyproject.toml
* Ruff: Target version py311
* Pyright: Python 3.11.9 with statistics


### Development Setup

1. Clone Repository
    ```bash
      git clone https://github.com/organization/python-base-project
      cd python-base-project
     ```
2. Install Dependencies as per [pyproject.toml]([pyproject.toml](pyproject.toml)) configuration file.
    ```bash
    make install
    ```

## Development Workflow

### Code Quality Enforcement

The project enforces code quality through automated tools:
1. Formatting
   * Applies Black formatting
   * Runs Ruff formatter
   * Organizes imports
   ```bash
    make format
    ```

2. Linting
	* Verifies Black formatting
	* Runs Ruff checks
	* Performs Pyright type checking
    ```bash
    make lint
    ```

3. Testing
    * Executes pytest suite
   ```bash
    make test
    ```
## Complete Build Process
To run the entire quality assurance pipeline

```bash
    make build
```
### This command executes:
1. Clean build artifacts
2. Install dependencies
3. Format code
4. Run linters
5. Execute tests
