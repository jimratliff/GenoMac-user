# ======================================================================
# Interactive guard
# ======================================================================
case $- in
  *i*) ;;        # interactive: proceed
  *) return ;;   # non-interactive: exit early
esac

# ======================================================================
# History policy (session-friendly, no dup spam)
# ======================================================================
setopt HIST_IGNORE_DUPS        # skip consecutive duplicates
setopt HIST_SAVE_NO_DUPS       # strip duplicates on save
setopt EXTENDED_HISTORY        # timestamps & durations in $HISTFILE
setopt APPEND_HISTORY          # append on exit (don’t clobber)
setopt INC_APPEND_HISTORY      # write as you go (session-local timing)
# setopt HIST_IGNORE_ALL_DUPS  # (optional) strict de-dupe across session
# setopt HIST_IGNORE_SPACE     # (optional) ignore cmds starting with space
# setopt HIST_EXPIRE_DUPS_FIRST # (optional) drop dups first on trim

# ======================================================================
# zsh-autocomplete (must be near the top; no manual compinit/compdef)
# ======================================================================
zstyle '*:compinit' arguments -i
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# ======================================================================
# Early env tweaks
# ======================================================================
# 1Password SSH agent (if present)
sock="$HOME/.1password/agent.sock"
[[ -S "$sock" ]] && export SSH_AUTH_SOCK="$sock"

# Default editor (leave existing value if already set)
: "${EDITOR:=bbedit}"

# Aliases alongside this .zshrc
[[ -r "$ZDOTDIR/.zsh_aliases" ]] && source "$ZDOTDIR/.zsh_aliases"

# ======================================================================
# fzf (split scripts; gentler than `source <(fzf --zsh)`)
# ======================================================================
[[ -r /opt/homebrew/opt/fzf/shell/completion.zsh   ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh
[[ -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# ======================================================================
# Plugins that should load after autocomplete
# ======================================================================
# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last among plugins)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ======================================================================
# Extras
# ======================================================================
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# ======================================================================
# Defensive key bindings (avoid missing-widget errors on ↑/↓)
# ======================================================================
if typeset -f .autocomplete__history-search__zle-widget >/dev/null; then
  bindkey '^[[A' .autocomplete__history-search__zle-widget
  bindkey '^[OA' .autocomplete__history-search__zle-widget
else
  bindkey '^[[A' up-line-or-history
  bindkey '^[OA' up-line-or-history
fi
bindkey '^[[B' down-line-or-history
bindkey '^[OB' down-line-or-history

# ======================================================================
# Friendly toast
# ======================================================================
echo "Zsh ready. 💡 Try 'show_aliases' or 'update_dotfiles' then 'reload_shell'."
