#!/bin/zsh

function set_keyboard_maestro_settings() {

  report_start_phase_standard
  report_action_taken "Implement Keyboard Maestro settings"
  
  local domain="com.stairways.keyboardmaestro"
  local domain_engine="com.stairways.keyboardmaestro.engine"
  local domain_editor="com.stairways.keyboardmaestro.editor"
  
  report_action_taken "Quit Keyboard Maestro if running to allow setting its settings"
  report_adjust_setting "Quitting the Editor"
  quit_app_by_bundle_id_if_running "$BUNDLE_ID_KEYBOARDMAESTRO_EDITOR" ; success_or_not
  report_adjust_setting "Quitting the Engine"
  quit_app_by_bundle_id_if_running "$BUNDLE_ID_KEYBOARDMAESTRO_ENGINE" ; success_or_not
  
  # Editor settings
  report_adjust_setting "Set: Do NOT show spash screen at launch"
  defaults write $domain_editor DisplayWelcomeWindow -bool false ; success_or_not
  
  # Engine settings
  report_adjust_setting "Set menu-bar status icon to Classic"
  defaults write $domain_engine StatusMenuIcon -string "Classic" ; success_or_not
  
  report_adjust_setting "Set: Do NOT show application palette"
  defaults write $domain_engine ShowApplicationsPalette -bool false ; success_or_not
  
  report_adjust_setting "Set: Include macro icons when listing macros in status menu"
  defaults write $domain_engine StatusMenuIncludeIcons -bool true ; success_or_not
  
  report_adjust_setting "Set: Do NOT list applications in status menu"
  defaults write $domain_engine StatusMenuIncludeApplications -bool false ; success_or_not
  
  report_adjust_setting "Set: Do NOT save recent applications between launches"
  defaults write $domain_engine SaveRecentApplicationsID -bool false ; success_or_not
  
  report_adjust_setting "Set: DO save clipboard history between launches"
  defaults write $domain_engine SaveClipboardHistory -bool true ; success_or_not
  
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
  
  local domain_editor="com.stairways.keyboardmaestro.editor"
  
  local bundle_id_engine="com.stairways.keyboardmaestro.engine"
  local bundle_id_editor="com.stairways.keyboardmaestro.editor"
  
  local macro_file_name="Keyboard Maestro Macros.kmsync"
  # Hint: GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${GENOMAC_USER_DROPBOX_DIRECTORY}/Preferences_common"
  local path_to_Keyboard_Maestro_subdirectory_in_Dropbox="$GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY/Keyboard_Maestro"
  local macro_file_path="${path_to_Keyboard_Maestro_subdirectory_in_Dropbox}/${macro_file_name}"
  
  report_action_taken "Quit Keyboard Maestro if running to allow changing its settings"
  report_adjust_setting "Quitting the Editor"
  quit_app_by_bundle_id_if_running "$bundle_id_editor" ; success_or_not
  report_adjust_setting "Quitting the Engine"
  quit_app_by_bundle_id_if_running "$bundle_id_engine" ; success_or_not
  
  # Editor settings
  report_adjust_setting "Set: Path to Keyboard Maestro macro file in Dropbox"
  defaults write $domain_editor MacroSharingFile -string "$macro_file_path" ; success_or_not
  
  report_end_phase_standard
}

