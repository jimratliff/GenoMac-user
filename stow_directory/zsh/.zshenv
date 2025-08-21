# Will result in a symlink at ~/.zshenv, where Zsh expects it to be.
# This will establish ZDOTDIR, to cause Zsh to look there for all Zsh configuration.
# This will then source the *real* .zshenv at ZDOTDIR.

export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Prefer XDG locations for volatile state
: "${XDG_STATE_HOME:=$HOME/.local/state}"

# Put history outside of ZDOTDIR
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000

# Ensure the directory exists
mkdir -p -- "$XDG_STATE_HOME/zsh"
