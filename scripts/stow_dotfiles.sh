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

function main() {
  stow_packages_dotfiles
}

main
