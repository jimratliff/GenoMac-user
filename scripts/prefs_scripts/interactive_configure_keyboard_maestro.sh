#!/bin/zsh

# Functions for the configuration of Keyboard Maestro
#
# - The script perform_basic_user_level_settings.sh executes set_keyboard_maestro_settings(),
#   which doesn’t require that Dropbox has synced
# - Later, after Dropbox has been configured to sync the common-preferences directory,
#   conditionally_configure_keyboard_maestro() should be executed to authenticate Keyboard Maestro
#   and set up macro syncing.

function conditionally_configure_keyboard_maestro() {
  report_start_phase_standard
  _run_if_not_already_done \
    "$PERM_KEYBOARD_MAESTRO_HAS_BEEN_CONFIGURED" \
    interactive_configure_keyboard_maestro \
    "Skipping bootstrapping of Keyboard Maestro, because this has been done in the past."
  report_end_phase_standard
}

function interactive_configure_keyboard_maestro() {
  # Bootstrap Keyboard Maestro for (a) authentication and (b) macro syncing
  # Because macro syncing relies on the existence of a directory in the user’s Dropbox directory,
  # this bootstrapping step must wait until Dropbox is configured for the user. (It is up
  # to the hypervisor to perform this check before calling this function.)

  report_start_phase_standard
  report_action_taken "I will bootstrap Keyboard Maestro for (a) authentication and (b) macro syncing"

  quit_keyboard_maestro_editor_and_engine
  set_keyboard_maestro_settings
  # Experimental: It’s untested whether the following `defaults write` will, on its own, configure
  # macro syncing with the local directory
  enable_keyboard_maestro_macro_syncing

  # Interactively prompt the user to authenticate Keyboard Maestro
  launch_app_and_prompt_user_to_act \
    --show-doc "${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/Keyboard_Maestro_how_to_configure.md" \
    "$BUNDLE_ID_KEYBOARDMAESTRO_EDITOR" \
    "Follow the instructions in the Quick Look window to log into and configure Keyboard Maestro"

    # TODO WIP TBD
  
  report_end_phase_standard
}

function set_keyboard_maestro_settings() {

  # This function performs the idempotent maintenace steps for Keyboard Maestro, which is
  # separate from the bootstrapping steps of (a) authentication and (b) setting up macro syncing

  report_start_phase_standard
  report_action_taken "Implement Keyboard Maestro settings"
  
  # Editor settings
  report_adjust_setting "Set: Do NOT show spash screen at launch"
  defaults write $DEFAULTS_DOMAINS_KEYBOARD_MAESTRO_EDITOR DisplayWelcomeWindow -bool false ; success_or_not
  
  # Engine settings
  report_adjust_setting "Set menu-bar status icon to Classic"
  defaults write $DEFAULTS_DOMAINS_KEYBOARD_MAESTRO_ENGINE StatusMenuIcon -string "Classic" ; success_or_not
  
  report_adjust_setting "Set: Do NOT show application palette"
  defaults write $DEFAULTS_DOMAINS_KEYBOARD_MAESTRO_ENGINE ShowApplicationsPalette -bool false ; success_or_not
  
  report_adjust_setting "Set: Include macro icons when listing macros in status menu"
  defaults write $DEFAULTS_DOMAINS_KEYBOARD_MAESTRO_ENGINE StatusMenuIncludeIcons -bool true ; success_or_not
  
  report_adjust_setting "Set: Do NOT list applications in status menu"
  defaults write $DEFAULTS_DOMAINS_KEYBOARD_MAESTRO_ENGINE StatusMenuIncludeApplications -bool false ; success_or_not
  
  report_adjust_setting "Set: Do NOT save recent applications between launches"
  defaults write $DEFAULTS_DOMAINS_KEYBOARD_MAESTRO_ENGINE SaveRecentApplicationsID -bool false ; success_or_not
  
  report_adjust_setting "Set: DO save clipboard history between launches"
  defaults write $DEFAULTS_DOMAINS_KEYBOARD_MAESTRO_ENGINE SaveClipboardHistory -bool true ; success_or_not
  
  report_end_phase_standard
}

function enable_keyboard_maestro_macro_syncing() {

  # Status as of 12/30/2025: EXPERIMENTAL
  # `make defaults-detective` perceived only one change following turning macro-syncing on,
  # and the current function addresses that change.
  # It is possible that the process of turning on syncing had additional side effects not replicated
  # by this function.

  report_start_phase_standard
  report_action_taken "Enable Keyboard Maestro macro syncing"
  
  local macro_file_name="Keyboard Maestro Macros.kmsync"
  # Hint: GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${GENOMAC_USER_DROPBOX_DIRECTORY}/Preferences_common"
  local path_to_Keyboard_Maestro_subdirectory_in_Dropbox="$GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY/Keyboard_Maestro"
  local macro_file_path="${path_to_Keyboard_Maestro_subdirectory_in_Dropbox}/${macro_file_name}"

  quit_keyboard_maestro_editor_and_engine
  
  # Editor settings
  report_adjust_setting "Set: Path to Keyboard Maestro macro file in Dropbox"
  defaults write $DEFAULTS_DOMAINS_KEYBOARD_MAESTRO_EDITOR MacroSharingFile -string "$macro_file_path" ; success_or_not
  
  report_end_phase_standard
}

function quit_keyboard_maestro_editor_and_engine() {
  report_start_phase_standard
  
  report_action_taken "Quit Keyboard Maestro if running to allow setting its settings"
  report_adjust_setting "Quitting the Editor"
  quit_app_by_bundle_id_if_running "$BUNDLE_ID_KEYBOARDMAESTRO_EDITOR" ; success_or_not
  report_adjust_setting "Quitting the Engine"
  quit_app_by_bundle_id_if_running "$BUNDLE_ID_KEYBOARDMAESTRO_ENGINE" ; success_or_not
  
  report_end_phase_standard
}

