#!/usr/bin/env zs

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Source required files
safe_source "${GMU_SCRIPTS_DIR}/stow_dotfiles.sh"
safe_source "${GMU_PREFS_SCRIPTS}/ask_initial_questions.sh"

local NAME_OF_PRESENT_MAKE_COMMAND="make run-hypervisor"

local welcome_message="Welcome"
if test_genomac_user_state "$GNU_SESH_SESSION_HAS_STARTED"; then
  welcome_message="Welcome back"
else
  set_genomac_user_state "$GNU_SESH_SESSION_HAS_STARTED"
fi

report "${welcome_message} to the GenoMac-user Hypervisor!"
report "To get back into the groove at any time, just reexecute ${NAME_OF_PRESENT_MAKE_COMMAND}\nand we’ll pick up where we left off."

if ! test_genomac_user_state "$GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED"; then
  ask_initial_questions
  set_genomac_user_state "$GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED"
else
  report_action_taken "Skipping introductory questions, because you’ve already answered them."
fi

if ! test_genomac_user_state "$GNU_SESH_DOTFILES_HAVE_BEEN_STOWED"; then 
  ensure_zshenv_loaded
  stow_packages_dotfiles
  set_genomac_user_state "$GNU_SESH_DOTFILES_HAVE_BEEN_STOWED"
else
  report_action_taken "Skipping stowing dotfiles, because you’ve already stowed them."
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
