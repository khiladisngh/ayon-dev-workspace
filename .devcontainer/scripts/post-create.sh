#!/bin/bash
# This script runs once as the non-root user (ayondev) after the container is created.
# It's responsible for all user-level setup, including shell configuration and
# Python environment setup.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration Variables ---
VENV_PATH="/home/ayondev/.venv"
PYTHON_EXEC_PATH="${VENV_PATH}/bin/python"
DOTFILES_DIR="/workspaces/ayon-dev-workspace/.dotfiles"

echo "🚀 Starting post-creation setup..."

# --- Zsh & Starship Setup ---
echo "🔧 Zsh, Oh My Zsh, and Starship installation..."

# Install Oh My Zsh non-interactively if it's not already installed.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh-autosuggestions plugin.
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting plugin.
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install Starship prompt.
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# --- Dotfiles Symlinking ---
# This is the key to managing your configuration as code.
echo "🔗 Symlinking dotfiles from repository to home directory..."
# Create the .config directory if it doesn't exist.
mkdir -p $HOME/.config
# Remove any existing default files and create symbolic links.
# This ensures that any changes you make to the files in your repo are reflected in the container.
ln -sf $DOTFILES_DIR/.zshrc $HOME/.zshrc
ln -sf $DOTFILES_DIR/.config/starship.toml $HOME/.config/starship.toml

# --- Python Environment Setup ---
echo "🐍 Creating Python virtual environment with uv..."
# Use the system's Python to create a virtual environment.
uv venv $VENV_PATH -p /usr/bin/python3.9

echo "📦 Installing project dependencies from pyproject.toml using uv..."
# **CRITICAL FIX**: Use '--all-extras' to install development dependencies (ruff, mypy, pytest).
# We also install the project in editable mode so changes to the source are reflected.
$VENV_PATH/bin/uv pip sync pyproject.toml --all-extras
$VENV_PATH/bin/uv pip install -e .

# --- Git Setup ---
echo "⚙️ Configuring Git and installing pre-commit hooks..."
# Install the pre-commit hooks into your .git/hooks directory.
# This automates code quality checks before you commit.
$VENV_PATH/bin/pre-commit install

echo "✅ Post-creation setup complete! Your environment is ready."
echo "💡 Tip: Close and reopen your VS Code terminal to see all changes."
echo "Happy coding! ✨"

