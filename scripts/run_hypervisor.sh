#!/usr/bin/env zs

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Source required files
safe_source "${GMU_PREFS_SCRIPTS}/interactive_ask_initial_questions.sh"
safe_source "${GMU_PREFS_SCRIPTS}/interactive_configure_1password.sh"
safe_source "${GMU_PREFS_SCRIPTS}/interactive_configure_dropbox.sh"
safe_source "${GMU_PREFS_SCRIPTS}/interactive_configure_textexpander.sh"
safe_source "${GMU_PREFS_SCRIPTS}/perform_basic_user_level_settings.sh"
safe_source "${GMU_PREFS_SCRIPTS}/perform_initial_bootstrap_operations.sh"
safe_source "${GMU_PREFS_SCRIPTS}/perform_stow_dotfiles.sh"

function run_hypervisor() {

  report_start_phase_standard

  # TODO:
  # - Consider checking $set_genomac_user_state "$GMU_SESH_REACHED_FINALITY" to
  #   check whether this is an immediate reentry after a complete session and,
  #   if so, to ask whether the user wants to start a new session.
  # - Consider adding environment variable GMU_SESH_FORCED_LOGOUT_DIRTY to avoid
  #   gratuitous logouts. An action requiring --forced-logout would (a) set this
  #   state rather than immediately triggering a logout.
  #   Requires new function `hypervisor_forced_logout_if_dirty`

  ############### Welcome! or Welcome back!
  local welcome_message="Welcome"
  if test_genomac_user_state "$GMU_SESH_SESSION_HAS_STARTED"; then
    welcome_message="Welcome back"
  else
    set_genomac_user_state "$GMU_SESH_SESSION_HAS_STARTED"
  fi
  
  report "${welcome_message} to the GenoMac-user Hypervisor!"
  report "$GMU_HYPERVISOR_HOW_TO_RESTART_STRING"
  
  ############### Ask initial questions
  _run_if_not_done \
    "$GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED" \
    ask_initial_questions \
    "Skipping introductory questions, because you've answered them in the past."
  
  ############### Stow dotfiles
  _run_if_not_done \
    --force-logout \
    "$GMU_SESH_DOTFILES_HAVE_BEEN_STOWED" \
    stow_dotfiles \
    "Skipping stowing dotfiles, because you've already stowed them during this session."

  ############### Configure primary programmatically implemented settings
  _run_if_not_done 
    --force-logout \
    "$GMU_SESH_BASIC_IDEMPOTENT_SETTINGS_HAVE_BEEN_IMPLEMENTED" \
    perform_basic_user_level_settings \
    "Skipping basic user-level settings, because they’ve already been set this session"

  ############### Modify Desktop for certain users
  if test_genomac_user_state "$GMU_PERM_FINDER_SHOW_DRIVES_ON_DESKTOP"; then
    _run_if_not_done \
      "$GMU_SESH_SHOW_DRIVES_ON_DESKTOP_HAS_BEEN_IMPLEMENTED" \
      reverse_disk_display_policy_for_some_users \
      "Skipping displaying internal/external drives on Desktop, because I’ve already done so this session"
  else
    report_action_taken "Skipping displaying internal/external drives on Desktop, because this user doesn’t want it"
  fi
  
  ############### Execute pre-Dropbox bootstrap steps
  _run_if_not_done \
    --force-logout \
    "$GMU_PERM_BASIC_BOOTSTRAP_OPERATIONS_HAVE_BEEN_PERFORMED" \
    perform_initial_bootstrap_operations \
    "Skipping basic bootstrap operations, because they’ve already been performed"

  ############### Conditionally configure TextExpander
  conditionally_authenticate_TextExpander

  ############### Conditionally configure 1Password
  conditionally_configure_1Password

  ############### Conditionally configure Dropbox
  conditionally_configure_dropbox

  ############### (Further) configure apps that rely upon Dropbox
  if test_genomac_user_state "$GMU_PERM_DROPBOX_HAS_BEEN_CONFIGURED"; then
    interactive_configure_alfred
    interactive_configure_keyboard_maestro
  fi


  ############### Execute post–Dropbox sync operations

  ############### Configure Microsoft Word
  conditionally_configure_microsoft_word

  ############### Last act: Delete all GMU_SESH_ state environment variables

  delete_all_GMU_SESH_states

  set_genomac_user_state "$GMU_SESH_REACHED_FINALITY"
  # TODO: Un-comment-out the below 'figlet' line after GenoMac-system is refactored so that it works
  # figlet "The End"
  hypervisor_force_logout
  report_end_phase_standard
}

function main() {
  run_hypervisor
}

main
