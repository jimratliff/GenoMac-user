#!/usr/bin/env zs

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Source required files
safe_source "${GMU_PREFS_SCRIPTS}/ask_initial_questions.sh"
safe_source "${GMU_PREFS_SCRIPTS}/perform_initial_bootstrap_operations.sh"
safe_source "${GMU_PREFS_SCRIPTS}/set_initial_user_level_settings.sh"
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

  if ! test_genomac_user_state "$GMU_SESH_BASIC_IDEMPOTENT_SETTINGS_HAVE_BEEN_IMPLEMENTED"; then
    set_initial_user_level_settings
    set_genomac_user_state "$GMU_SESH_BASIC_IDEMPOTENT_SETTINGS_HAVE_BEEN_IMPLEMENTED"
  else
    report_action_taken "Skipping basic user-level settings, because they’ve already been set this session."
  fi

  ############### Modify Desktop for certain users
  conditionally_show_drives_on_desktop

  ############### Execute pre-Dropbox bootstrap steps
  if ! test_genomac_user_state "$GMU_PERM_BASIC_BOOTSTRAP_OPERATIONS_HAVE_BEEN_PERFORMED"; then
    perform_initial_bootstrap_operations
    set_genomac_user_state "$GMU_PERM_BASIC_BOOTSTRAP_OPERATIONS_HAVE_BEEN_PERFORMED"
  else
    report_action_taken "Skipping basic bootstrap operations, because they’ve already been performed."
  fi




  ############### Execute post–Dropbox sync operations

  ############### Configure Microsoft Word

  conditionally_configure_microsoft_word

  ############### Last act: Delete all GMU_SESH_ state environment variables

  # TBD
  

  report_end_phase_standard
}

function conditionally_configure_microsoft_word() {
  report_start_phase_standard

  if ! test_genomac_user_state "$GMU_PERM_USER_WILL_USE_MICROSOFT_WORD"; then
    report_action_taken "Skipping Microsoft Word configuration, because this user doesn’t want it"
    report_end_phase_standard
    exit 0
  fi

  if test_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_HAS_BEEN_CONFIGURED"; then
    report_action_taken "Skipping Microsoft Word configuration, because it’s already been configured and it’s a bootstrapping step"
    report_end_phase_standard
    exit 0
  fi

  if ! test_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_HAS_BEEN_AUTHENTICATED"; thenthen
    # You can’t change Microsoft Word’s settings unless the app is first authenticated
    local bundle_id_microsoft_word="com.microsoft.Word"
    local prompt="I will launch Microsoft Word. Please log in to your Microsoft 365 account. This is necessary for me to set its preferences"
    launch_app_and_prompt_user_to_authenticate "$bundle_id_microsoft_word" "$prompt"
    set_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_HAS_BEEN_AUTHENTICATED"
  fi

  set_microsoft_office_suite_wide_settings
  set_microsoft_word_settings

  set_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_HAS_BEEN_CONFIGURED"

  report_end_phase_standard
}

function conditionally_show_drives_on_desktop() {
  report_start_phase_standard
  
  if ! test_genomac_user_state "$GMU_PERM_SHOW_DRIVES_ON_DESKTOP"; then
    report_action_taken "Skipping displaying internal/external drives on Desktop, because this user doesn’t want it"
    report_end_phase_standard
    exit 0
  fi

  if test_genomac_user_state "$GMU_SESH_SHOW_DRIVES_ON_DESKTOP_HAS_BEEN_IMPLEMENTED"; then
    report_action_taken "Skipping displaying internal/external drives on Desktop, because I’ve already done so this session"
    report_end_phase_standard
    exit 0
  fi

  reverse_disk_display_policy_for_some_users

  set_genomac_user_state "$GMU_SESH_SHOW_DRIVES_ON_DESKTOP_HAS_BEEN_IMPLEMENTED"
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
