# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# --- Oh My Zsh Theme ---
# We're leaving the theme minimal ("") because Starship will be taking over the prompt.
ZSH_THEME=""

# --- Oh My Zsh Plugins ---
# A curated list of plugins for a great terminal experience.
plugins=(
    git
    docker
    docker-compose
    python
    pip
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh.
source $ZSH/oh-my-zsh.sh

# --- User Configuration & Environment Variables ---
export PATH="$HOME/.local/bin:$PATH"

# Python environment variables for cleaner execution.
export PYTHONUNBUFFERED=1
export PIP_NO_CACHE_DIR=1
export PYTHONDONTWRITEBYTECODE=1

# --- Aliases for Productivity ---
# These aliases use the tools we installed in the Dockerfile (exa, bat, fd, rg).
alias ll='exa -la --group-directories-first'
alias la='exa -a --group-directories-first'
alias ls='exa --group-directories-first'
alias tree='exa --tree'
alias cat='bat'
alias find='fd'
alias grep='rg'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gp='git push'
alias gl='git pull'

# Docker aliases
alias dc='docker-compose'

# Python aliases
# We point directly to the virtual environment's python for clarity.
alias python='$HOME/.venv/bin/python'
alias pip='uv pip'

# --- Tool Initializations ---

# Initialize Starship prompt - must be the last line related to the prompt.
eval "$(starship init zsh)"

# Load fzf keybindings and completion if it exists.
# This makes Ctrl+T and Ctrl+R work for finding files and history.
if command -v fzf &> /dev/null; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
fi

# Activate the Python virtual environment automatically for new terminals.
source $HOME/.venv/bin/activate
