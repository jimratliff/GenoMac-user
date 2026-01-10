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
safe_source "${GMU_PREFS_SCRIPTS}/set_1password_configuration.sh"

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

############### SUPPORTING FUNCTIONS ###############

function _run_based_on_state() {
  # Executes a function based on whether a state variable is set or not.
  # Core helper that powers both _run_if_not_already_done and _run_if_state.
  #
  # Usage:
  #   _run_based_on_state [--negate-state] [--force-logout] <state_var> <func_to_run> <skip_message>
  #
  # Flags can appear in any position.
  #
  # Parameters:
  #   --negate-state  Optional. If present, runs func_to_run when state is NOT set.
  #                   If absent, runs func_to_run when state IS set.
  #   --force-logout  Optional. If present, calls hypervisor_force_logout after execution.
  #   state_var       The state variable to check (e.g., $GMU_SESH_...).
  #   func_to_run     Name of the function to execute if condition is met.
  #   skip_message    Message to display if condition is not met and action is skipped.
  #
  # If func_to_run is executed, then state_var is SET. (This has effect only when --negate-state,
  # because when --negate-state is absent, func_to_run is executed only when state_var is already set.)

  local negate_state=false
  local force_logout=false
  local positional=()
  
  # Parse arguments - flags can appear anywhere
  while (( $# > 0 )); do
    case "$1" in
      --negate-state)
        negate_state=true
        shift
        ;;
      --force-logout)
        force_logout=true
        shift
        ;;
      *)
        positional+=("$1")
        shift
        ;;
    esac
  done

  # Validate positional argument count
  if (( ${#positional[@]} != 3 )); then
    report_fail "Error: expected 3 positional arguments (state_var, func_to_run, skip_message), got ${#positional[@]}"
    return 1
  fi

  local state_var="${positional[1]}"
  local func_to_run="${positional[2]}"
  local skip_message="${positional[3]}"

  # Determine whether to run based on state and negation flag
  local should_run=false
  if $negate_state; then
    # Run if state is NOT set
    test_genomac_user_state "$state_var" || should_run=true
  else
    # Run if state IS set
    test_genomac_user_state "$state_var" && should_run=true
  fi

  if $should_run; then
    $func_to_run
    set_genomac_user_state "$state_var"
    if $force_logout; then
      hypervisor_force_logout
    fi
  else
    report_action_taken "$skip_message"
  fi
}

function _run_if_not_already_done() {
  # Executes a function if a completion state variable is false (absent) indicating a task hasn't been done yet.
  # Sets the state variable after successful execution.
  #
  # Usage:
  #   _run_if_not_already_done [--force-logout] <state_var> <func_to_run> <skip_message>
  #
  # Flags can appear in any position.
  #
  # Parameters:
  #   --force-logout  Optional. If present, calls hypervisor_force_logout after setting state.
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

  _run_based_on_state --negate-state "$@"
}

function _run_if_state() {
  # Executes a function if a completion state variable is true (present) indicating a task has been done.
  #
  # Usage:
  #   _run_if_state [--force-logout] <state_var> <func_to_run> <skip_message>
  #
  # Flags can appear in any position.
  #
  # Parameters:
  #   --force-logout  Optional. If present, calls hypervisor_force_logout after execution.
  #   state_var       The state variable to check (e.g., $GMU_SESH_...).
  #   func_to_run     Name of the function to execute if state is set.
  #   skip_message    Message to display if state is not set and action is skipped.

  _run_based_on_state "$@"
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
