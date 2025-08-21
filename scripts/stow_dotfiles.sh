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
         "$package" 
    success_or_not
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
  
  # Ensure state dirs/files exist
  report_action_taken "Creating directories only if necessary: '$XDG_STATE_HOME/zsh' & '$XDG_STATE_HOME/zsh/sessions'"
  mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_STATE_HOME/zsh/sessions" ; success_or_not
  report_action_taken "Remove in unlikely case that it exists: '$XDG_STATE_HOME/zsh/history'"
  : > "$XDG_STATE_HOME/zsh/history" ; success_or_not
  report_action_taken "Set permissions of '$XDG_STATE_HOME/zsh/history'"
  chmod 600 "$XDG_STATE_HOME/zsh/history" ; success_or_not

  # Point sessions at state (idempotent & safe)
  if [[ -e "$ZDOTDIR/.zsh_sessions" && ! -L "$ZDOTDIR/.zsh_sessions" ]]; then
    report_action_taken "Delete existing sessions directory in .config"
    rm -rf "$ZDOTDIR/.zsh_sessions" ; success_or_not
  fi
  report_action_taken "Create symbolic link from .config to '$XDG_STATE_HOME/zsh/sessions'"
  ln -snf "$XDG_STATE_HOME/zsh/sessions" "$ZDOTDIR/.zsh_sessions" ; success_or_not

  report_success "Zsh sessions will be stored at '$XDG_STATE_HOME/zsh/sessions'"
  report_end_phase_standard
}

function main() {
  stow_packages_dotfiles
  prepare_zsh_sessions_for_outside_zdotdir
}

main
