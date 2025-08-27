# Skip the rest of .zshrc unless in an interactive shell
case $- in
  *i*) ;;  # interactive: proceed
  *) return ;;  # non-interactive: bail out
esac

############### Snippets that should appear near the top

# History policy
setopt HIST_IGNORE_DUPS       # skip consecutive duplicates
setopt HIST_SAVE_NO_DUPS      # strip duplicates on save
setopt EXTENDED_HISTORY       # timestamps & durations in $HISTFILE
setopt APPEND_HISTORY         # append on exit (don’t clobber)
setopt INC_APPEND_HISTORY     # write as you go (session-local timing)
# If you ever want strict uniqueness across the whole session, use this instead:
# setopt HIST_IGNORE_ALL_DUPS
# Optional niceties:
# setopt HIST_IGNORE_SPACE     # commands starting with space are not saved
# setopt HIST_EXPIRE_DUPS_FIRST # expire dups first when trimming history

# Enable zsh-autocomplete
# The -i flag: ignore warnings the group-writable Homebrew directories are insecure
zstyle '*:compinit' arguments -i
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Automatically use 1Password SSH agent if present
sock="$HOME/.1password/agent.sock"
if [[ -S "$sock" ]]; then
  export SSH_AUTH_SOCK="$sock"
fi

# Sets default EDITOR if not already set
: "${EDITOR:=bbedit}"   # or "nano", "nvim", "vim", "code", etc.

# Source aliases file, .zsh_aliases, assumed in the same directory as this .zshrc file
source "$ZDOTDIR/.zsh_aliases"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

############### Snippets that should be “at the end”

# Enable zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable zoxide
eval "$(zoxide init zsh)"

# Enable starship
eval "$(starship init zsh)"

############### Final bit: interactive shell only
# [[ -o interactive ]] && echo "Zsh ready. \n💡 You might try 'show_aliases' or 'update_dotfiles' followed by 'reload_shell'."
echo "Zsh ready. \n💡 You might try 'show_aliases' or 'update_dotfiles' followed by 'reload_shell'."
