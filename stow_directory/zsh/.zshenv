# Will result in a symlink at ~/.zshenv, where Zsh expects it to be.
# This will establish ZDOTDIR, to cause Zsh to look there for all Zsh configuration.
# This will then source the *real* .zshenv at ZDOTDIR.

export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
source "$ZDOTDIR/.zshenv"
