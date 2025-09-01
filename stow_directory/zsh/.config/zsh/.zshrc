# ======================================================================
# Interactive guard
# ======================================================================
case $- in
  *i*) ;;        # interactive: proceed
  *) return ;;   # non-interactive: exit early
esac

# ======================================================================
# Homebrew prefix helpers (no export)
# ======================================================================
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(/usr/bin/env brew --prefix 2>/dev/null || true)}"
HOMEBREW_ZSH_PREFIX="$(/usr/bin/env brew --prefix zsh 2>/dev/null)"

# ======================================================================
# Programmable completion (native zsh)
# - Use `compinit -i` to silence "insecure directories" warnings (like
#   those that can arise from permissions of Homebrew directories)
# ======================================================================
typeset -U fpath
core_dir="$HOMEBREW_ZSH_PREFIX/share/zsh/functions"
[[ -z "$HOMEBREW_ZSH_PREFIX" || ! -d "$core_dir" ]] && core_dir="/usr/share/zsh/$ZSH_VERSION/functions"
[[ -d "$core_dir" ]] && fpath=("$core_dir" $fpath)
[[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

autoload -Uz compinit
compinit -i

# ======================================================================
# History policy (interactive opts only)
# ----------------------------------------------------------------------
# NOTE:
# - File location and size (HISTFILE, HISTSIZE, SAVEHIST) are set in
#   ~/.zshenv so *all* shells agree, interactive or not.
# - Only interactive behaviors are configured here.
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
# Environment conveniences
# ======================================================================
# 1Password SSH agent (if present)
sock="$HOME/.1password/agent.sock"
[[ -S "$sock" ]] && export SSH_AUTH_SOCK="$sock"

# Default editor (respect existing value if set upstream)
: "${EDITOR:=bbedit}"

# ======================================================================
# Aliases (located adjacent to this .zshrc file)
# ======================================================================
[[ -r "$ZDOTDIR/.zsh_aliases" ]] && source "$ZDOTDIR/.zsh_aliases"

# ======================================================================
# zoxide (TAB completion via compinit; `zi` uses fzf if installed)
# ======================================================================
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"

  # Override `z` to auto-fallback to interactive picker when ambiguous result
  z() {
    if [[ $# -eq 0 ]]; then
      zi; return
    fi

    local -a matches
    matches=("${(@f)$(zoxide query -l -- "$@")}")

    if (( ${#matches} == 0 )); then
      print -u2 "z: no match for: $*"
      return 1
    elif (( ${#matches} == 1 )); then
      builtin cd -- "${matches[1]}"
    else
      local target
      target="$(zoxide query -i -- "$@")" || return
      [[ -n $target ]] && builtin cd -- "$target"
    fi
  }
fi

# ======================================================================
# zsh-autosuggestions (history-based ghost text)
# ======================================================================
[[ -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# ======================================================================
# zsh-syntax-highlighting (must be last among plugins)
# ======================================================================
[[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ======================================================================
# Prompt
# ======================================================================
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ======================================================================
# Friendly toast
# ======================================================================
echo "Zsh ready. 💡 Try 'show_aliases' or 'update_dotfiles' then 'reload_shell'."
