# ======================================================================
# Interactive guard
# ======================================================================
case $- in
  *i*) ;;        # interactive: proceed
  *) return ;;   # non-interactive: exit early
esac

# ======================================================================
# History policy
# ======================================================================
setopt HIST_IGNORE_DUPS        # skip consecutive duplicates
setopt HIST_SAVE_NO_DUPS       # strip duplicates on save
setopt EXTENDED_HISTORY        # timestamps & durations in $HISTFILE
setopt APPEND_HISTORY          # append on exit (don’t clobber)
setopt INC_APPEND_HISTORY      # write as you go
# Optional:
# setopt HIST_IGNORE_ALL_DUPS
# setopt HIST_IGNORE_SPACE
# setopt HIST_EXPIRE_DUPS_FIRST

# ======================================================================
# Homebrew prefix (local to this shell; no export)
# ======================================================================
HB_PREFIX="${HB_PREFIX:-$(/usr/bin/env brew --prefix 2>/dev/null || true)}"

# ======================================================================
# zsh-autocomplete (must be near the top; do NOT call compinit yourself)
# Keep system $fpath; ensure plugin dir is on $fpath before sourcing.
# ======================================================================
typeset -U fpath
ac_dir="$HB_PREFIX/share/zsh-autocomplete"
[[ -d $ac_dir && ${fpath[(Ie)$ac_dir]} -eq 0 ]] && fpath=("$ac_dir" $fpath)
zstyle '*:compinit' arguments -i
[[ -r "$ac_dir/zsh-autocomplete.plugin.zsh" ]] && source "$ac_dir/zsh-autocomplete.plugin.zsh"

# ======================================================================
# Early env & convenience
# ======================================================================
# 1Password SSH agent (if present)
sock="$HOME/.1password/agent.sock"
[[ -S "$sock" ]] && export SSH_AUTH_SOCK="$sock"

# Default editor (respect existing value)
: "${EDITOR:=bbedit}"

# Aliases alongside this .zshrc
[[ -r "$ZDOTDIR/.zsh_aliases" ]] && source "$ZDOTDIR/.zsh_aliases"

# ======================================================================
# fzf (split scripts; gentler than `source <(fzf --zsh)`)
# ======================================================================
[[ -r "$HB_PREFIX/opt/fzf/shell/completion.zsh"   ]] && source "$HB_PREFIX/opt/fzf/shell/completion.zsh"
[[ -r "$HB_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] && source "$HB_PREFIX/opt/fzf/shell/key-bindings.zsh"

# ======================================================================
# Plugins after autocomplete
# ======================================================================
# zsh-autosuggestions
[[ -r "$HB_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$HB_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting (must be last among plugins)
[[ -r "$HB_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$HB_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ======================================================================
# Extras
# ======================================================================
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

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
