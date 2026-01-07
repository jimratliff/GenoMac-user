#!/usr/bin/env zs

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Source required files
safe_source "${GMU_PREFS_SCRIPTS}/ask_initial_questions.sh"
safe_source "${GMU_PREFS_SCRIPTS}/stow_dotfiles.sh"

function run_hypervisor() {

  report_start_phase_standard

  ############### Welcome! or Welcome back!
  local welcome_message="Welcome"
  if test_genomac_user_state "$GNU_SESH_SESSION_HAS_STARTED"; then
    welcome_message="Welcome back"
  else
    set_genomac_user_state "$GNU_SESH_SESSION_HAS_STARTED"
  fi
  
  report "${welcome_message} to the GenoMac-user Hypervisor!"
  report "$GMU_HYPERVISOR_HOW_TO_RESTART_STRING"
  
  ############### Ask initial questions
  if ! test_genomac_user_state "$GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED"; then
    ask_initial_questions
    set_genomac_user_state "$GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED"
  else
    report_action_taken "Skipping introductory questions, because you’ve already answered them."
  fi
  
  ############### Stow dotfiles
  if ! test_genomac_user_state "$GMU_SESH_DOTFILES_HAVE_BEEN_STOWED"; then 
    ensure_zshenv_loaded
    stow_dotfiles
    set_genomac_user_state "$GMU_SESH_DOTFILES_HAVE_BEEN_STOWED"
    dump_accumulated_warnings_failures
    hypervisor_force_logout
  else
    report_action_taken "Skipping stowing dotfiles, because you’ve already stowed them."
  fi

  ############### Configure programmatically implemented settings

  # Add basic prefs here

  ############### Configure Microsoft Word
  

  report_end_phase_standard
}

function conditionally_configure_microsoft_word() {
  report_start_phase_standard

  if test_genomac_user_state "$GMU_PERM_USER_WILL_USE_MICROSOFT_WORD"; then
    if ! test_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_HAS_BEEN_CONFIGURED"; then
      if ! test_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_HAS_BEEN_AUTHENTICATED"; then
        launch_microsoft_word_and_prompt_user_to_authenticate
        set_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_HAS_BEEN_AUTHENTICATED"
      else
        report_action_taken "Skipping authenticating Microsoft Word, because it’s already authenticated"
      fi
      set_microsoft_office_suite_wide_settings
      set_microsoft_word_settings
    else
      report_action_taken "Skipping Microsoft Word configuration, because it’s already been done"
    fi
  else
    report_action_taken "Skipping Microsoft Word configuration, because you don’t it"
  fi

  report_end_phase_standard
}



function hypervisor_force_logout() {
  echo ""
  echo "ℹ️  You will be logged out semi-automatically to fully internalize all the work we’ve done."
  echo "   Please log back in."
  echo "   $GMU_HYPERVISOR_HOW_TO_RESTART_STRING."
  echo ""

  force_user_logout
}

function main() {
  run_hypervisor
}

main
