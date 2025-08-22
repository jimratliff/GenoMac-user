# XDG roots
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"

# Zsh config root
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Zsh state (helper vars for humans/scripts)
export XDG_ZSH_STATE_DIR="$XDG_STATE_HOME/zsh"
export XDG_ZSH_SESSIONS_DIR="$XDG_ZSH_STATE_DIR/sessions"

# History: Zsh itself reads HISTFILE, so export it
export HISTFILE="$XDG_ZSH_STATE_DIR/history"
export HISTSIZE=${HISTSIZE:-100000}
export SAVEHIST=${SAVEHIST:-100000}
