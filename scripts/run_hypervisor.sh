#!/usr/bin/env zs

# Fail early on unset variables or command failure
set -euo pipefail

# Template for entry-point scripts

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Source required files
# safe_source "${GMU_PREFS_SCRIPTS}/install_btt_license.sh"

if ! test_genomac_user_state "$GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED"; then
  ask_initial_questions
  set_genomac_user_state "$GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED"
fi

if ! test_genomac_user_state "$GNU_SESH_DOTFILES_HAVE_BEEN_STOWED"; then 
  ensure_zshenv_loaded
  stow_packages_dotfiles
  set_genomac_user_state "$GNU_SESH_DOTFILES_HAVE_BEEN_STOWED"
fi

function some_function() {
  report_start_phase_standard

  report "I am doing something important"

  report_end_phase_standard

}

function main() {
  some_function
}

main
