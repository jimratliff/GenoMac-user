#!/usr/bin/env zsh

# Source required files
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_ask_initial_questions.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_1password.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_alfred.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_dropbox.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_keyboard_maestro.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_screensaver.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_textexpander.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_set_waterfox_extension_preferences.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/perform_basic_user_level_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/perform_initial_bootstrap_operations.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/perform_stow_dotfiles.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_apps_to_launch_at_login.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_waterfox_settings.sh"

function subdermis() {

  report_start_phase_standard

  # TODO:
  # - Consider adding environment variable SESH_FORCED_LOGOUT_DIRTY to avoid
  #   gratuitous logouts. An action requiring --forced-logout would (a) set this
  #   state rather than immediately triggering a logout.
  #   Requires new function `hypervisor_forced_logout_if_dirty`

  output_hypervisor_welcome_banner "$GENOMAC_SCOPE_USER"
  set_genomac_user_state "$SESH_SESSION_HAS_STARTED"

  interactive_ensure_terminal_has_fda
  conditionally_interactive_ask_initial_questions
  conditionally_stow_dotfiles
  conditionally_perform_basic_user_level_settings
  conditionally_reverse_disk_display_policy_for_some_users
  
  conditionally_implement_waterfox_settings_and_install_extensions
  conditionally_interactive_set_preferences_for_waterfox_extensions
  
  # Execute pre-Dropbox bootstrap steps
  conditionally_perform_initial_bootstrap_operations
  conditionally_interactive_configure_screensaver

  # 1Password will configured at this point in order to be available when subsequent
  # apps need to be signed into
  conditionally_configure_1Password

  conditionally_configure_textexpander
  conditionally_configure_Dropbox

  ############### PERM: (Further) configure apps that rely upon Dropbox having synced
  if test_genomac_user_state "$PERM_DROPBOX_HAS_BEEN_CONFIGURED"; then
    conditionally_configure_keyboard_maestro

    # Alfred must be configured *after* Keyboard Maestro, because activating the
    # Powerpack uses a custom Keyboard Maestro macro
    conditionally_configure_alfred
  fi

  conditionally_configure_microsoft_word

  conditionally_set_apps_to_launch_at_login
  
  report_end_phase_standard
}



