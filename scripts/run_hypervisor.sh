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
safe_source "${GMU_PREFS_SCRIPTS}/verify_ssh_agent_configuration.sh"

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
  _run_if_not_done "$GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED" \
    ask_initial_questions \
    "Skipping introductory questions, because you've answered them in the past."
  
  ############### Stow dotfiles
  _run_if_not_done --force-logout "$GMU_SESH_DOTFILES_HAVE_BEEN_STOWED" \
    stow_dotfiles \
    "Skipping stowing dotfiles, because you've already stowed them during this session."

  ############### Configure primary programmatically implemented settings
  _run_if_not_done --force-logout "$GMU_SESH_BASIC_IDEMPOTENT_SETTINGS_HAVE_BEEN_IMPLEMENTED" \
    set_initial_user_level_settings \
    "Skipping basic user-level settings, because they’ve already been set this session"

  ############### Modify Desktop for certain users
  if test_genomac_user_state "$GMU_PERM_FINDER_SHOW_DRIVES_ON_DESKTOP"; then
    _run_if_not_done "$GMU_SESH_SHOW_DRIVES_ON_DESKTOP_HAS_BEEN_IMPLEMENTED" \
      reverse_disk_display_policy_for_some_users \
      "Skipping displaying internal/external drives on Desktop, because I’ve already done so this session"
  else
    report_action_taken "Skipping displaying internal/external drives on Desktop, because this user doesn’t want it"
  fi
  
  ############### Execute pre-Dropbox bootstrap steps
  _run_if_not_done "$GMU_PERM_BASIC_BOOTSTRAP_OPERATIONS_HAVE_BEEN_PERFORMED" \
    perform_initial_bootstrap_operations \
    "Skipping basic bootstrap operations, because they’ve already been performed"

  ############### Configure 1Password
  # At this point, (a) GenoMac-system has installed both 1Password.app and the 1Password-CLI app and 
  # (b) GenoMac-user has deployed dotfiles necessary for the integration of 1Password with GitHub authentication
  
  conditionally_configure_1Password

  ############### Configure Dropbox ################# WIP
  if test_genomac_user_state "$GMU_PERM_USER_WILL_USE_DROPBOX"; then
    _run_if_not_done "$GMU_PERM_DROPBOX_HAS_BEEN_AUTHENTICATED" \
      authenticate_dropbox \
      "Skipping basic bootstrap operations, because they’ve already been performed"
  fi

  function authenticate_dropbox() {
    # Display instructions in a separate, Quick Look window
    doc_to_show="${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/Dropbox_how_to_log_in.md"
    show_file_using_quicklook "$doc_to_show"

    # Launch app and wait for acknowledgment from user
    prompt="Log into your Dropbox account in the Dropbox app"
    launch_app_and_prompt_user_to_act "$BUNDLE_ID_DROPBOX" "$prompt"
    set_genomac_user_state "$GMU_PERM_DROPBOX_HAS_BEEN_AUTHENTICATED"

  }

  # Prompt user to authenticate their 1Password account in the 1Password app on the Mac
  if ! test_genomac_user_state "$GMU_PERM_1PASSWORD_HAS_BEEN_AUTHENTICATED"; then
    report_action_taken "Time to authenticate 1Password! I’ll launch it, and open a window with instructions for logging into 1Password"

    # Display instructions in a separate, Quick Look window
    doc_to_show="${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/1Password_how_to_log_in.md"
    show_file_using_quicklook "$doc_to_show"

    # Launch app and wait for acknowledgment from user
    prompt="Log into your 1Password account in the 1Password app"
    launch_app_and_prompt_user_to_act "$BUNDLE_ID_1PASSWORD" "$prompt"
    set_genomac_user_state "$GMU_PERM_1PASSWORD_HAS_BEEN_AUTHENTICATED"

  else
    report_action_taken "Skipping authenticating 1Password, because it’s already been authenticated and it’s a bootstrapping step"
  fi





  ############### Execute post–Dropbox sync operations

  ############### Configure Microsoft Word

  conditionally_configure_microsoft_word

  ############### Last act: Delete all GMU_SESH_ state environment variables

  # TBD

  set_genomac_user_state "$GMU_SESH_REACHED_FINALITY"
  # TODO: Un-comment-out the below 'figlet' line after GenoMac-system is refactored so that it works
  # figlet "The End"
  hypervisor_force_logout
  report_end_phase_standard
}

############### SUPPORTING FUNCTIONS ###############

function conditionally_configure_1Password() {
  # It is assumed that all users want to be authenticated with 1Password.
  # However, each user can choose whether to configure 1Password’s SSH agent
  #
  # It is assumed that: if a user has configured 1Password, then that user has also authenticated 1Password
  
  report_start_phase_standard

  local doc_to_show
  local prompt

  # Skip if 1Password has been previously configured for this user (even in an earlier session)
  if test_genomac_user_state "$GMU_PERM_1PASSWORD_HAS_BEEN_CONFIGURED"; then
    report_action_taken "Skipping 1Password configuration, because it’s already been configured and it’s a bootstrapping step"
    report_end_phase_standard
    exit 0
  fi

  # Prompt user to authenticate their 1Password account in the 1Password app on the Mac
  if ! test_genomac_user_state "$GMU_PERM_1PASSWORD_HAS_BEEN_AUTHENTICATED"; then
    report_action_taken "Time to authenticate 1Password! I’ll launch it, and open a window with instructions for logging into 1Password"

    # Display instructions in a separate, Quick Look window
    doc_to_show="${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/1Password_how_to_log_in.md"
    show_file_using_quicklook "$doc_to_show"

    # Launch app and wait for acknowledgment from user
    prompt="Log into your 1Password account in the 1Password app"
    launch_app_and_prompt_user_to_act "$BUNDLE_ID_1PASSWORD" "$prompt"
    set_genomac_user_state "$GMU_PERM_1PASSWORD_HAS_BEEN_AUTHENTICATED"

  else
    report_action_taken "Skipping authenticating 1Password, because it’s already been authenticated and it’s a bootstrapping step"
  fi

  # Skip configuration of SSH agent if user doesn’t want to go through that trouble
  if ! test_genomac_user_state "$GMU_PERM_1PASSWORD_USER_WANTS_TO_CONFIGURE_SSH_AGENT"; then
    report_action_taken "Skipping 1Password configuration, because this user doesn’t want it"
    report_end_phase_standard
    exit 0
  fi
  
  # Prompt user to configure settings of 1Password
  report_action_taken "Time to configure 1Password! I’ll launch it, and open a window with instructions to follow"
  
  # Display instructions in a separate, Quick Look window
  doc_to_show="${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/1Password_how_to_configure.md"
  show_file_using_quicklook "$doc_to_show"

  # Launch app and wait for acknowledgment from user
  prompt="Follow the instructions to configure 1Password"
  launch_app_and_prompt_user_to_act "$BUNDLE_ID_1PASSWORD" "$prompt"
  set_genomac_user_state "$GMU_PERM_1PASSWORD_HAS_BEEN_AUTHENTICATED"

  # Verify configuration of SSH Agent
  if ! verify_ssh_agent_configuration; then
    report_fail "The attempt to configure 1Password to SSH authenticate with GitHub has failed ☹️"
    report_end_phase_standard
    exit 1
  else
    report success "✅ 1Password successfully configured to SSH authenticate with GitHub"
    set_genomac_user_state "$GMU_PERM_1PASSWORD_HAS_BEEN_CONFIGURED"
  fi
  report_end_phase_standard
}

function conditionally_configure_microsoft_word() {
  report_start_phase_standard

  if ! test_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_USER_WANTS_IT"; then
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
    local prompt="I will launch Microsoft Word. Please log in to your Microsoft 365 account. This is necessary for me to set its preferences"
    launch_app_and_prompt_user_to_authenticate "$BUNDLE_ID_MICROSOFT_WORD" "$prompt"
    set_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_HAS_BEEN_AUTHENTICATED"
  fi

  set_microsoft_office_suite_wide_settings
  set_microsoft_word_settings

  set_genomac_user_state "$GMU_PERM_MICROSOFT_WORD_HAS_BEEN_CONFIGURED"

  report_end_phase_standard
}

function _run_if_not_already_done() {
  # Executes a function if a completion state variable is false (absent) indicating a task hasn't been done yet.
  # Sets the state variable after successful execution.
  #
  # Usage:
  #   _run_if_not_already_done [--force-logout] <state_var> <func_to_run> <skip_message>
  #
  # Parameters:
  #   --force-logout  Optional. If present, calls hypervisor_force_logout after
  #                   setting state.
  #   state_var       The state variable to check and set (e.g., $GMU_SESH_...).
  #   func_to_run     Name of the function to execute if state is not set.
  #   skip_message    Message to display if state is already set and action is skipped.
  #
  # Usage examples:
  #   _run_if_not_already_done "$GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED" \
  #     ask_initial_questions \
  #     "Skipping introductory questions, because you've answered them in the past."
  #   
  #   _run_if_not_already_done --force-logout "$GMU_SESH_DOTFILES_HAVE_BEEN_STOWED" \
  #     stow_dotfiles \
  #     "Skipping stowing dotfiles, because you've already stowed them during this session."

  local force_logout=false
  if [[ $1 == "--force-logout" ]]; then
    force_logout=true
    shift
  fi

  local state_var=$1
  local func_to_run=$2
  local skip_message=$3

  if ! test_genomac_user_state "$state_var"; then
    $func_to_run
    set_genomac_user_state "$state_var"
    if $force_logout; then
      hypervisor_force_logout
    fi
  else
    report_action_taken "$skip_message"
  fi
}

function hypervisor_force_logout() {
  echo ""
  echo "ℹ️  You will be logged out semi-automatically to fully internalize all the work we’ve done."
  echo "   Please log back in."
  echo "   $GMU_HYPERVISOR_HOW_TO_RESTART_STRING."
  echo ""

  dump_accumulated_warnings_failures
  force_user_logout
}

function main() {
  run_hypervisor
}

main
