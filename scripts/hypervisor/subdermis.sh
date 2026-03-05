#!/usr/bin/env zsh

# Source required files
safe_source "${GMU_INSTALLATION_SCRIPTS}/install_witch_prefpane.sh"
safe_source "${GMU_INSTALLATION_SCRIPTS}/install_zed_icon_theme.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_ask_initial_questions.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_1password.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_alfred.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_dropbox.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_helium.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_keyboard_maestro.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_screensaver.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_textexpander.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_create_mission_control_spaces.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_set_waterfox_extension_preferences.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/perform_basic_user_level_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/perform_initial_bootstrap_operations.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/perform_stow_dotfiles.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_apps_to_launch_at_login.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_bettertouchtool_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_mission_control_assign_to_options.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_waterfox_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_witch_settings.sh"

function subdermis() {

  report_start_phase_standard

  # TODO:
  # - Consider adding environment variable SESH_FORCED_LOGOUT_DIRTY to avoid
  #   gratuitous logouts. An action requiring --forced-logout would (a) set this
  #   state rather than immediately triggering a logout.
  #   - Requires new function `hypervisor_forced_logout_if_dirty`
  #   - Possibly should also require a `defaults write` helper that first does a `defaults read`
  #     and then does the defaults write only if it would change state. Only if it would change
  #     state, then set a dirty flag.

  output_hypervisor_welcome_banner "$GENOMAC_SCOPE_USER"
  set_genomac_user_state "$SESH_SESSION_HAS_STARTED"

  interactive_ensure_terminal_has_fda
  
  conditionally_interactive_ask_initial_questions
  
  conditionally_stow_dotfiles
  conditionally_perform_basic_user_level_settings
  conditionally_reverse_disk_display_policy_for_some_users
  
  conditionally_implement_waterfox_settings_and_install_extensions
  interactive_set_preferences_for_waterfox_extensions

  conditionally_interactive_configure_helium_and_extensions
  
  # Execute pre-Dropbox bootstrap steps
  conditionally_perform_initial_bootstrap_operations
  conditionally_interactive_configure_screensaver
  conditionally_install_zed_icon_theme
  conditionally_configure_microsoft_word

  # Configure 1Password here to make available credentials for later steps
  conditionally_configure_1Password

  ############### BELOW THIS POINT: 1Password credentials are available

  conditionally_configure_textexpander
  conditionally_configure_Dropbox
  conditionally_interactive_configure_waterfox_raindropio_extension

  ############### PERM: (Further) configure apps that rely upon Dropbox having synced
  if test_genomac_user_state "$PERM_DROPBOX_HAS_BEEN_CONFIGURED"; then

    # BetterTouchTool relies on Dropbox because that’s where its license file is stored
    conditionally_configure_bettertouchtool

    # Keyboard Maestro relies on Dropbox because that’s where its synced preferences are stored
    conditionally_configure_keyboard_maestro

    # Alfred must be configured *after* Keyboard Maestro, because activating the
    # Powerpack uses a custom Keyboard Maestro macro
    conditionally_configure_alfred

    # Installation of Witch preference pane relies on Dropbox as the source of the binary
    # Installed for each user separately because Witch pref pane won’t launch automatically at login
    # when installed systemwide
    conditionally_install_witch_prefpane_for_user

    # Installation of Witch license files relies on Dropbox because that’s where its license files are stored
    conditionally_install_Witch_license_files
    conditionally_interactive_enable_Witch
  fi

  conditionally_create_additional_mission_control_spaces

  conditionally_set_apps_to_launch_at_login
  
  report_end_phase_standard
}



