#!/bin/bash
set -e

echo "Installing Zsh configuration and Starship prompt..."

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install Starship prompt
echo "Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# Create starship config directory
mkdir -p ~/.config

# Create a basic starship configuration
cat > ~/.config/starship.toml << 'EOF'
# Starship configuration for Ayon development
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$python\
$docker_context\
$character"""

[username]
show_always = true
format = "[$user]($style)@"

[hostname]
ssh_only = false
format = "[$hostname]($style) "

[directory]
truncation_length = 3
truncate_to_repo = false

[git_branch]
format = "on [$symbol$branch]($style) "

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'

[python]
format = 'via [${symbol}${pyenv_prefix}(${version} )(\($virtualenv\) )]($style)'

[docker_context]
format = "via [🐳 $context](blue bold)"

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
EOF

# Create .zshrc configuration
cat > ~/.zshrc << 'EOF'
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Plugins to load
plugins=(
    git
    docker
    docker-compose
    python
    pip
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="$HOME/.local/bin:$PATH"

# Python environment variables
export PYTHONUNBUFFERED=1
export PIP_NO_CACHE_DIR=1
export PYTHONDONTWRITEBYTECODE=1

# Aliases for better command line experience
alias ll='exa -la --group-directories-first'
alias la='exa -a --group-directories-first'
alias ls='exa --group-directories-first'
alias tree='exa --tree'
alias cat='batcat'
alias find='fd'
alias grep='rg'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Docker aliases
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcl='docker-compose logs'

# Python aliases
alias py='python'
alias pip='python -m pip'
alias venv='python -m venv'

# Ayon specific aliases
alias ayon='python -m ayon_core'
alias ayon-launcher='python -m ayon_launcher'

# Initialize Starship prompt
eval "$(starship init zsh)"

# Load fzf if available
if command -v fzf &> /dev/null; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
fi

EOF

echo "Zsh and Starship installation completed!"
EOF