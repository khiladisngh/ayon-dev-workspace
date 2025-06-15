# Ayon Development Environment - ZSH Configuration

# Plugins
plugins=(
    git
    python
    pip
    docker
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
)

source $ZSH/oh-my-zsh.sh

# Starship prompt
eval "$(starship init zsh)"

# FZF integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# UV configuration
export UV_CACHE_DIR="/workspace/.uv-cache"
export UV_PYTHON_PREFERENCE="only-managed"

# Python development aliases
alias py="python"
alias ipy="ipython"
alias pytest="python -m pytest"
alias mypy="python -m mypy"
alias ruff="python -m ruff"

# UV shortcuts
alias uv-install="uv pip install"
alias uv-dev="uv pip install -e ."
alias uv-sync="uv pip sync"
alias uv-lock="uv lock"

# Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline"
alias gd="git diff"

# Development shortcuts
alias ll="exa -la"
alias cat="bat"
alias find="fd"
alias grep="rg"

# Ayon specific aliases
alias ayon-test="pytest -v"
alias ayon-lint="ruff check ."
alias ayon-format="ruff format ."
alias ayon-check="mypy ."

# Auto-activate virtual environment when entering workspace
autoload -U add-zsh-hook
activate_venv() {
    if [[ -f "/workspace/.venv/bin/activate" && "$VIRTUAL_ENV" != "/workspace/.venv" ]]; then
        source /workspace/.venv/bin/activate
    fi
}
add-zsh-hook chpwd activate_venv

# Activate on shell start if in workspace
if [[ "$PWD" == "/workspace"* && -f "/workspace/.venv/bin/activate" ]]; then
    source /workspace/.venv/bin/activate
fi

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=/home/${USERNAME}/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Welcome message for new shells
if [[ $SHLVL -eq 1 ]]; then
    echo "🎨 Ayon Development Environment"
    echo "Type 'uv --help' for package management or 'make help' for project commands"
fi
