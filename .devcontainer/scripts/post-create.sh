#!/bin/bash

# This script runs as the 'remoteUser' (ayondev) after the container is created.
# It sets up the Python environment and shell customizations.

# Exit immediately if a command exits with a non-zero status.
set -e

USERNAME="ayondev"
VENV_PATH="/home/${USERNAME}/.venv"
PYTHON_EXEC_PATH="${VENV_PATH}/bin/python"

echo "🔧 Setting up Python virtual environment and shell customizations..."
# Source the .zshrc file to load environment variables and aliases.
source /home/${USERNAME}/.zshrc

echo "🐍 Creating Python virtual environment with uv..."
# Use the system's Python 3.9 to create a virtual environment.
uv venv $VENV_PATH -p /usr/local/bin/python

echo "📦 Installing project dependencies from pyproject.toml using uv..."
# Use 'uv pip sync' which is very fast and ensures the venv matches the toml file exactly.
# --all-extras installs development dependencies as well.
uv pip sync pyproject.toml --python $PYTHON_EXEC_PATH

echo "✅ Post-creation setup complete! Your environment is ready."
echo "Happy coding! 🚀"
