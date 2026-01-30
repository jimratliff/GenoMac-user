#!/usr/bin/env zsh

# “Stows” the dotfiles in GMU_STOW_DIR (which were supplied
# by the `stow_directory` of this repo) by creating corresponding symlinks 
# in the home directory using GNU Stow.
#
# Assumes that:
# - GNU Stow has been installed by GenoMac-system.
# - This repo has been cloned locally to GENOMAC_USER_LOCAL_DIRECTORY.
# - Thus, the `stow_directory` of this repo is cloned to 
#   GMU_STOW_DIR (typically, 
#   `~/.genomac-user/stow_directory`).
# - GMU_ARRAY_OF_PACKAGES_TO_STOW_DOTFILES is an environment variable that is an array
#   of the names of packages whose dotfiles should be stowed.
#
# (The above all-caps environment variables are defined in the script 
# assign_user_environment_variables.sh, which is sourced shortly below.)

# Fail early on unset variables or command failure
set -euo pipefail

function stow_dotfiles() {
  report_start_phase_standard

  ensure_zshenv_loaded
  stow_dotfiles_for_each_package
  prepare_zsh_sessions_for_outside_zdotdir

  report_end_phase_standard
}

function ensure_zshenv_loaded() {
  # Address mysterious issue whereby ~/.zshenv appears not to be loaded
  # Ensure .zshenv variables are present in THIS zsh process
  
  report_start_phase_standard
  report_action_taken "Ensuring that ~/.zshenv is loaded"
  
  if [[ -z "${ZDOTDIR:-}" || -z "${XDG_STATE_HOME:-}" || -z "${HISTFILE:-}" ]]; then
    if [[ -r "${ZDOTDIR:-$HOME}/.zshenv" ]]; then
      source "${ZDOTDIR:-$HOME}/.zshenv"
    elif [[ -r "$HOME/.zshenv" ]]; then
      source "$HOME/.zshenv"
    fi
  fi

  report_end_phase_standard
}

function stow_dotfiles_for_each_package() {
  report_start_phase_standard

  # Set verbosity level for stow command from 0,…,5
  local STOW_VERBOSITY=0

  for package in "${GMU_ARRAY_OF_PACKAGES_TO_STOW_DOTFILES[@]}"; do
    report_action_taken "Stowing package: $package"
    stow --dir="$GMU_STOW_DIR" \
         --target="$HOME" \
         --adopt \
         --ignore='\.DS_Store' \
         --verbose=$STOW_VERBOSITY \
         "$package" ; success_or_not
  done

  (
    report_action_taken "Resetting GenoMac-user repo to discard any adopted file content"
    cd "$GENOMAC_USER_LOCAL_DIRECTORY"
    git reset --hard ; success_or_not
  )

  report "Dotfiles all symlinked. To make aliases, etc., available: source ~/.config/zsh/.zshrc"
  report_end_phase_standard
}

function prepare_zsh_sessions_for_outside_zdotdir() {
  # Implements some details to allow Zsh sessions to be stored outside of ZDOTDIR.

  report_start_phase_standard
  report_action_taken "Preparing Zsh sessions to be stored outside of .config"

  # --- Load environment (ZDOTDIR / XDG vars) if this shell didn't read .zshenv ---
  if [[ -z "${ZDOTDIR:-}" || -z "${XDG_STATE_HOME:-}" || -z "${HISTFILE:-}" || -z "${XDG_ZSH_STATE_DIR:-}" || -z "${XDG_ZSH_SESSIONS_DIR:-}" ]]; then
    if [[ -r "$HOME/.zshenv" ]]; then
      # Source the HOME entry point (respects your stow layout and any future refactors)
      source "$HOME/.zshenv"
    fi
  fi
  
  # FYI: The following are defined in .zshenv: 
  #      XDG_CONFIG_HOME, XDG_STATE_HOME, ZDOTDIR, XDG_ZSH_STATE_DIR, XDG_ZSH_SESSIONS_DIR, HISTFILE

  # Fail fast if invariants from .zshenv aren't present
  : "${ZDOTDIR:?ZDOTDIR is not set. Check ~/.zshenv.}"
  : "${XDG_STATE_HOME:?XDG_STATE_HOME is not set. Check ~/.zshenv.}"
  : "${HISTFILE:?HISTFILE is not set. Check ~/.zshenv.}"
  : "${XDG_ZSH_STATE_DIR:?XDG_ZSH_STATE_DIR is not set. Check ~/.zshenv.}"
  : "${XDG_ZSH_SESSIONS_DIR:?XDG_ZSH_SESSIONS_DIR is not set. Check ~/.zshenv.}"

  # Ensure state directories exist
  report_action_taken "Ensuring state dirs: '$XDG_ZSH_STATE_DIR' & '$XDG_ZSH_SESSIONS_DIR'"
  mkdir -p "$XDG_ZSH_STATE_DIR" "$XDG_ZSH_SESSIONS_DIR" ; success_or_not

  # Create history only if missing; do not modify existing contents or timestamps
  if [[ ! -e "$HISTFILE" ]]; then
    report_action_taken "Creating empty history '$HISTFILE' (0600)"
    umask 077
    : > "$HISTFILE"
    chmod 600 "$HISTFILE"
    success_or_not
  else
    report_action_taken "History exists at '$HISTFILE' — leaving as-is"
  fi

  # Sessions: enforce symlink from $ZDOTDIR/.zsh_sessions -> $XDG_ZSH_SESSIONS_DIR
  ZDOT_SESS_PATH="$ZDOTDIR/.zsh_sessions"
  if [[ -e "$ZDOT_SESS_PATH" && ! -L "$ZDOT_SESS_PATH" ]]; then
    echo "ERROR: '$ZDOT_SESS_PATH' exists and is not a symlink. Resolve manually, then re-run." >&2
    return 1
  fi

  report_action_taken "Linking '$ZDOT_SESS_PATH' -> '$XDG_ZSH_SESSIONS_DIR' (idempotent)"
  ln -snf "$XDG_ZSH_SESSIONS_DIR" "$ZDOT_SESS_PATH" ; success_or_not

  report_success "Zsh sessions will be stored at '$XDG_STATE_HOME/zsh/sessions'"
  report_end_phase_standard
}
