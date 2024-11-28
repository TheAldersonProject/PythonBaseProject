#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Function to check if a command exists and is executable
command_exists() {
    command -v "$1" >/dev/null 2>&1 && [ -x "$(command -v "$1")" ]
}

# Function to install pyenv
install_pyenv() {
    echo "Installing pyenv..."
    if [ -d "$HOME/.pyenv" ]; then
        echo "Removing existing .pyenv directory..."
        rm -rf "$HOME/.pyenv"
    fi
    curl https://pyenv.run | bash

    # Add pyenv to PATH
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    source ~/.bashrc
}

# Function to install and configure Poetry
install_and_configure_poetry() {
    echo "Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -

    # Add Poetry to PATH
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc

    # Verify Poetry installation
    if command_exists poetry; then
        echo "Poetry installed successfully."
    else
        echo "Poetry installation failed. Please install it manually and update your PATH."
        exit 1
    fi
}

# Store the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Script directory: $SCRIPT_DIR"

# Check if pyenv is installed and working
if command_exists pyenv; then
    echo "pyenv is already installed and working."
else
    install_pyenv
fi

# Check if Poetry is installed and working
if command_exists poetry; then
    echo "Poetry is already installed and working."
else
    install_and_configure_poetry
fi

# Read project details from project_config.toml
project_name=$(grep '^project_name' "$SCRIPT_DIR/project_config.toml" | cut -d '"' -f2)
python_version=$(grep '^python_version' "$SCRIPT_DIR/project_config.toml" | cut -d '"' -f2)
git_repo_url=$(grep '^repo_url' "$SCRIPT_DIR/project_config.toml" | cut -d '"' -f2)
git_initial_branch=$(grep '^initial_branch' "$SCRIPT_DIR/project_config.toml" | cut -d '"' -f2)

echo "Creating project: $project_name"

# Create a new project directory in the parent folder
project_dir="$SCRIPT_DIR/../$project_name"
echo "Creating project directory: $project_dir"
mkdir -p "$project_dir"
echo "Changing to project directory"
cd "$project_dir"
echo "Current directory: $(pwd)"

# Install the specified Python version using pyenv
echo "Installing Python $python_version..."
pyenv install $python_version -s
pyenv local $python_version

# Copy pyproject.toml from the root folder
echo "Copying pyproject.toml from $SCRIPT_DIR to $(pwd)"
cp "$SCRIPT_DIR/pyproject.toml" .

# Create project structure
echo "Creating project structure"
mkdir -p src/$project_name tests
touch src/$project_name/__init__.py
touch tests/__init__.py
echo "Project structure created"

# Create a README.md file
echo "Creating README.md"
cat > README.md << EOL
# $project_name

## Setup

1. Ensure you have Python $python_version installed.
2. Install Poetry: \`curl -sSL https://install.python-poetry.org | python3 -\`
3. Clone this repository: \`git clone $git_repo_url\`
4. Navigate to the project directory: \`cd $project_name\`
5. Install dependencies: \`poetry install\`
6. Activate the virtual environment: \`poetry shell\`

## Usage

Describe how to use your project here.

## Development

This project uses a Makefile for common tasks. Here are the available commands:

- \`make setup\`: Set up the project (install dependencies and set up Git)
- \`make install\`: Install or update dependencies
- \`make format\`: Format code using Black and isort
- \`make lint\`: Run linters (mypy, flake8, pylint)
- \`make test\`: Run tests
- \`make clean\`: Remove build artifacts
- \`make build\`: Run all checks and tests
- \`make check\`: Check code quality (format, lint, test)
- \`make git-setup\`: Initialize Git repository (if not already done)

Run \`make help\` to see all available commands.

## License

Specify your project's license here.
EOL
echo "README.md created"

# Create a .gitignore file
echo "Creating .gitignore"
cat > .gitignore << EOL
# Python
__pycache__/
*.py[cod]
*$py.class
.pytest_cache/

# Virtual environment
.venv/
venv/

# Poetry
poetry.lock

# IDEs
.vscode/
.idea/

# Miscellaneous
.DS_Store
EOL
echo ".gitignore created"

# Copy Makefile to the new project directory and replace placeholders
if [ -f "$SCRIPT_DIR/Makefile_template" ]; then
    echo "Creating Makefile from template"
    sed -e "s|GIT_REPO_URL|$git_repo_url|g" \
        -e "s|GIT_INITIAL_BRANCH|$git_initial_branch|g" \
        "$SCRIPT_DIR/Makefile_template" > Makefile
    echo "Makefile created from template with Git information."
else
    echo "Makefile_template not found in the script directory. Skipping Makefile creation."
fi

# Initialize Git repository
if [ -n "$git_repo_url" ]; then
    echo "Initializing Git repository"
    git init
    git branch -M "$git_initial_branch"
    git remote add origin "$git_repo_url"

    echo "Git repository initialized with remote: $git_repo_url"
    echo "Initial branch set to: $git_initial_branch"

    # Make initial commit
    git add .
    git commit -m "Initial commit"

    echo "Initial commit created. To push to remote, use: git push -u origin $git_initial_branch"
else
    echo "No Git repository URL specified in project_config.toml. Skipping Git initialization."
fi

# Create and activate the virtual environment
echo "Creating virtual environment..."
poetry env use python$python_version
poetry install

echo "Python project created successfully in $project_dir"
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

echo
echo "Virtual environment created and dependencies installed."
echo "To activate the virtual environment, run: poetry shell"
echo
echo "To use this project:"
echo "1. Navigate into the project directory: cd $project_name"
echo "2. Activate the virtual environment: poetry shell"
echo "3. Start developing!"
echo
echo "To push your initial commit to the remote repository:"
echo "git push -u origin $git_initial_branch"