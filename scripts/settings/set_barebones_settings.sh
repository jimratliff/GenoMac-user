#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/set_alan_app_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_app_state_persistence.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_auto_correction_suggestion_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_basic_mission_control_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_control_center_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_diskutility_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_finder_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_general_dock_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_general_interface_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_keyboard_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_menubar_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_notifications_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_preview_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_safari_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_screen_capture_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_symbolichotkeys.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_terminal_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_trackpad_settings.sh"

function conditionally_perform_barebones_user_level_settings() {
  report_start_phase_standard

  run_if_user_has_not_done \
    --force-logout \
    "$SESH_BAREBONES_SETTINGS_HAVE_BEEN_IMPLEMENTED" \
    perform_barebones_user_level_settings \
    "Skipping barebones user-level settings, because they’ve already been set this session"
  
  report_end_phase_standard
}

function perform_barebones_user_level_settings() {
  report_start_phase_standard

  set_app_state_persistence                     # scripts/settings/set_app_state_persistence.sh
  set_trackpad_settings                         # scripts/settings/set_trackpad_settings.sh
  set_general_interface_settings                # scripts/settings/set_general_interface_settings.sh
  set_auto_correction_suggestion_settings       # scripts/settings/set_auto_correction_suggestion_settings.sh
  set_keyboard_related_defaults                 # scripts/settings/set_keyboard_settings.sh
  set_symbolichotkeys                           # scripts/settings/set_symbolichotkeys.sh
  set_menubar_settings                          # scripts/settings/set_menubar_settings.sh
  set_control_center_settings                   # scripts/settings/set_control_center_settings.sh
  set_general_dock_settings                     # scripts/settings/set_general_dock_settings.sh
  set_screen_capture_settings                   # scripts/settings/set_screen_capture_settings.sh
  set_basic_mission_control_settings            # scripts/settings/set_basic_mission_control_settings.sh
  set_notifications_settings                    # scripts/settings/set_notifications_settings.sh
  
  # Language & Region
  # Week starts on Monday
  report_adjust_setting "Language & Region: Week starts on Monday"
  defaults write -g AppleFirstWeekday -dict gregorian -int 2
  
  # Time Machine
  report_adjust_setting "Time Machine: Don’t prompt to use new disk as backup volume"
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true ; success_or_not

  # Apple-app settings
  set_finder_settings                           # scripts/settings/set_finder_settings.sh
  set_preview_settings                          # scripts/settings/set_preview_settings.sh
  set_diskutility_settings                      # scripts/settings/set_diskutility_settings.sh
  set_terminal_settings                         # scripts/settings/set_terminal_settings.sh
  set_safari_settings                            # scripts/settings/set_safari_settings.sh
  
  # Text Edit
  report_adjust_setting "Text Edit: Make plain text the default format"
  defaults write com.apple.TextEdit RichText -bool false ; success_or_not
  
  ############### VERY SELECTIVE THIRD-PARTY APPLICATION(S)
  report_action_taken "Begin settings for third-party applications"
  
  # Alan.app
  set_alan_app_settings

  report_end_phase_standard                      # scripts/settings/set_alan_app_settings.sh
}
