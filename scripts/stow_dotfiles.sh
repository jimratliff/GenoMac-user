#!/usr/bin/env zsh

# “Stows” the dotfiles in GENOMAC_USER_LOCAL_STOW_DIRECTORY (which were supplied
# by the `stow_directory` of this repo) by creating corresponding symlinks 
# in the home directory using GNU Stow.
#
# Assumes that:
# - GNU Stow has been installed by GenoMac-system.
# - This repo has been cloned locally to GENOMAC_USER_LOCAL_DIRECTORY.
# - Thus, the `stow_directory` of this repo is cloned to 
#   GENOMAC_USER_LOCAL_STOW_DIRECTORY (typically, 
#   `~/.genomac-user/stow_directory`).
# - The names of packages whose dotfiles are to be stowed are listed in 
#   the below PACKAGES_LIST variable.
#
# (The above all-caps environment variables are defined in the script 
# assign_environment_variables.sh, which is sourced shortly below.)

# Fail early on unset variables or command failure
set -euo pipefail

# Address mysterious issue whereby ~/.zshenv appears not to be loaded
# Ensure .zshenv variables are present in THIS zsh process
if [[ -z "${ZDOTDIR:-}" || -z "${XDG_STATE_HOME:-}" || -z "${HISTFILE:-}" ]]; then
  # Prefer $ZDOTDIR/.zshenv when ZDOTDIR is set; fallback to $HOME/.zshenv
  if [[ -r "${ZDOTDIR:-$HOME}/.zshenv" ]]; then
    # shellcheck disable=SC1090
    source "${ZDOTDIR:-$HOME}/.zshenv"
  elif [[ -r "$HOME/.zshenv" ]]; then
    # shellcheck disable=SC1090
    source "$HOME/.zshenv"
  fi
fi

# Resolve this script's directory (even if sourced)
this_script_path="${0:A}"
this_script_dir="${this_script_path:h}"

# Assign environment variables (including GENOMAC_HELPER_DIR).
# Assumes that assign_environment_variables.sh is in same directory as the
# current script.
source "${this_script_dir}/assign_environment_variables.sh"

# Source helpers
source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER #############################
function stow_packages_dotfiles() {
  report_start_phase_standard

  # Set verbosity level for stow command from 0,…,5
  # local STOW_VERBOSITY=2
  local STOW_VERBOSITY=0

  local PACKAGES_LIST=("1password" "git" "homebrew" "ssh" "starship" "stow" "zsh")

  for package in "${PACKAGES_LIST[@]}"; do
    report_action_taken "Stowing package: $package"
    stow --dir="$GENOMAC_USER_LOCAL_STOW_DIRECTORY" \
         --target="$HOME" \
         --adopt \
         --ignore='\.DS_Store' \
         --verbose=$STOW_VERBOSITY \
         "$package" ; success_or_not
  done

  (
    report_action_taken "Resetting genomac-user repo to discard any adopted file content"
    cd "$GENOMAC_USER_LOCAL_DIRECTORY"
    git reset --hard; success_or_not
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
    exit 1
  fi

  report_action_taken "Linking '$ZDOT_SESS_PATH' -> '$XDG_ZSH_SESSIONS_DIR' (idempotent)"
  ln -snf "$XDG_ZSH_SESSIONS_DIR" "$ZDOT_SESS_PATH" ; success_or_not

  report_success "Zsh sessions will be stored at '$XDG_STATE_HOME/zsh/sessions'"
  report_end_phase_standard
}

function main() {
  stow_packages_dotfiles
  prepare_zsh_sessions_for_outside_zdotdir
  
  report_action_taken "Deploying “stowing” of dotfiles complete. Logging out to apply system-wide changes..."
  echo ""
  echo "ℹ️  You will be logged out automatically to take into account the stowed dotfiles."
  echo "   After logging back in, continue with the next configuration step."
  echo ""

  force_user_logout
}

main
