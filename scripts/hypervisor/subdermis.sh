#!/usr/bin/env zsh

# Source required files
safe_source "${GMU_INSTALLATION_SCRIPTS}/install_witch_prefpane.sh"
safe_source "${GMU_INSTALLATION_SCRIPTS}/make_development_clones.sh"
safe_source "${GMU_INSTALLATION_SCRIPTS}/make_repositories_directory_for_developers.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_ask_initial_questions.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_1password.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_alfred.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_dropbox.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_helium.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_keyboard_maestro.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_screensaver.sh"
# safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_textexpander.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_create_mission_control_spaces.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_set_git_config_user.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_set_waterfox_extension_preferences.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/perform_basic_user_level_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/perform_initial_bootstrap_operations.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/perform_stow_dotfiles.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_apps_to_launch_at_login.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_bettertouchtool_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_mission_control_assign_to_options.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_waterfox_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_witch_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/user_attribute_scripts.sh"

function subdermis() {

  report_start_phase_standard

  # TODO:
  # - Consider adding environment variable SESH_FORCED_LOGOUT_DIRTY to avoid gratuitous logouts.
  #   An action requiring --forced-logout would (a) set this state rather than immediately
  #   triggering a logout.
  #   - Requires new function `hypervisor_forced_logout_if_dirty`
  #   - Possibly should also require a `defaults write` helper that first does a `defaults read`
  #     and then does the defaults write only if it would change state. Only if it would change
  #     state, then set a dirty flag.

  output_hypervisor_welcome_banner "$GENOMAC_SCOPE_USER"      # GenoMac-shared/scripts/helpers-hypervisor.sh
  set_genomac_user_state "$SESH_SESSION_HAS_STARTED"
  
  conditionally_interactive_ask_initial_questions             # scripts/settings/interactive_ask_initial_questions.sh
  keep_sudo_alive                                             # GenoMac-shared/scripts/helpers-misc.sh
  interactive_ensure_terminal_has_fda                         # GenoMac-shared/scripts/helpers-misc.sh
  transfer_system_scoped_user_attribute_states_to_user_scoped # scripts/settings/user_attribute_scripts.sh.
  set_user_preferences_from_attributes                        # scripts/settings/user_attribute_scripts.sh
  conditionally_set_git_config_user                           # scripts/settings/interactive_set_git_config_user.sh
  conditionally_stow_dotfiles                                 # scripts/settings/perform_stow_dotfiles.sh
  conditionally_perform_basic_user_level_settings             # scripts/settings/perform_basic_user_level_settings.sh
  conditionally_implement_waterfox_settings_and_install_extensions # scripts/settings/set_waterfox_settings.sh
  conditionally_interactive_configure_helium_and_extensions   # scripts/settings/interactive_configure_helium.sh

  # TODOs: conditionally_configure_mail_app
  conditionally_configure_mail_app                            # scripts/settings/set_mail_app_settings.sh

  # TODOs: conditionally_configure_hiarcs_ce_pro
  conditionally_configure_hiarcs_ce_pro                       # scripts/settings/set_hiarcs_cd_pro_settings.sh
  
  # Execute pre-Dropbox bootstrap steps
  conditionally_perform_initial_bootstrap_operations          # scripts/settings/perform_initial_bootstrap_operations.sh
  conditionally_interactive_configure_screensaver             # scripts/settings/interactive_configure_screensaver.sh
  conditionally_configure_microsoft_word                      # scripts/settings/set_microsoft_word_settings.sh

  # If user has 'developer' attribute, create ~/Repositories directory to hold clones
  conditionally_create_repositories_directory_for_developers
  
  # If user has 'genomac-developer' attribute, create additional local clones of GenoMac-system, GenoMac-user, and
  # GenoMac-shared at ~/Repositories/Project_GenoMac
  conditionally_clone_GenoMac_repos_for_development           # scripts/installations/make_development_clones.sh

  # Configure 1Password here to make available credentials for later steps
  conditionally_configure_1Password                           # scripts/settings/interactive_configure_1password.sh

  ############### BELOW THIS POINT: 1Password credentials are available ###############
  
  interactive_set_preferences_for_waterfox_extensions         # scripts/settings/interactive_set_waterfox_extension_preferences.sh
  conditionally_configure_Dropbox                             # scripts/settings/interactive_configure_dropbox.sh

  ############### (Further) configure apps that rely upon Dropbox having synced ###############
  if test_genomac_user_state "$PERM_DROPBOX_HAS_BEEN_CONFIGURED"; then
    # BetterTouchTool relies on Dropbox because that’s where its license file is stored
    conditionally_configure_bettertouchtool                   # scripts/settings/set_bettertouchtool_settings.sh

    # Keyboard Maestro relies on Dropbox because that’s where its synced preferences are stored
    conditionally_configure_keyboard_maestro                  # scripts/settings/interactive_configure_keyboard_maestro.sh

    # Alfred must be configured *after* Keyboard Maestro, because activating the Powerpack uses a custom Keyboard Maestro macro
    conditionally_configure_alfred                            # scripts/settings/interactive_configure_alfred.sh

    # Installation of Witch preference pane relies on Dropbox as the source of the binary.
    # Installed for each user separately because Witch pref pane won’t launch automatically at login
    # when installed systemwide.
    conditionally_install_witch_prefpane_for_user             # scripts/installations/install_witch_prefpane.sh

    # Installation of Witch license files relies on Dropbox because that’s where its license files are stored
    conditionally_install_Witch_license_files                 # scripts/settings/set_witch_settings.sh
    conditionally_interactive_enable_Witch                    # scripts/settings/set_witch_settings.sh
  fi

  conditionally_create_additional_mission_control_spaces      # scripts/settings/interactive_create_mission_control_spaces.sh
  conditionally_set_apps_to_launch_at_login                   # scripts/settings/set_apps_to_launch_at_login.sh
  unmark_current_user_as_in_need_of_initial_config            # GenoMac-shared/scripts/helpers-state-xfer-btw-system-user.sh
  display_users_to_be_initially_configured                    # GenoMac-shared/scripts/helpers-state-xfer-btw-system-user.sh
  
  report_end_phase_standard
}



