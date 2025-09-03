# ======================================================================
# Source system-wide zsh environment first
# ======================================================================
[[ -r /etc/zshenv ]] && source /etc/zshenv

# ======================================================================
# XDG roots (defaults; respect existing values)
# ======================================================================
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"

# ======================================================================
# Zsh config & state roots
# ======================================================================
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Helper paths for humans/scripts (not required by zsh itself)
export XDG_ZSH_STATE_DIR="$XDG_STATE_HOME/zsh"
export XDG_ZSH_SESSIONS_DIR="$XDG_ZSH_STATE_DIR/sessions"

# Ensure state dirs exist (cheap, idempotent; safe for non-interactive shells)
[[ -d $XDG_ZSH_STATE_DIR     ]] || mkdir -p "$XDG_ZSH_STATE_DIR"
[[ -d $XDG_ZSH_SESSIONS_DIR  ]] || mkdir -p "$XDG_ZSH_SESSIONS_DIR"

# ======================================================================
# History file location & sizes (zsh reads these even in non-interactive shells)
# ======================================================================
export HISTFILE="$XDG_ZSH_STATE_DIR/history"
export HISTSIZE=${HISTSIZE:-100000}
export SAVEHIST=${SAVEHIST:-100000}
