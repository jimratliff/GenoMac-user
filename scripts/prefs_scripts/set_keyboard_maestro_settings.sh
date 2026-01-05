#!/bin/zsh

function set_keyboard_maestro_settings() {

  report_start_phase_standard
  report_action_taken "Implement Keyboard Maestro settings"
  
  local domain="com.stairways.keyboardmaestro"
  local domain_engine="com.stairways.keyboardmaestro.engine"
  local domain_editor="com.stairways.keyboardmaestro.editor"
  
  local bundle_id_engine="com.stairways.keyboardmaestro.engine"
  local bundle_id_editor="com.stairways.keyboardmaestro.editor"
  
  report_action_taken "Quit Keyboard Maestro if running to allow setting its settings"
  report_adjust_setting "Quitting the Editor"
  quit_app_by_bundle_id_if_running "$bundle_id_editor" ; success_or_not
  report_adjust_setting "Quitting the Engine"
  quit_app_by_bundle_id_if_running "$bundle_id_engine" ; success_or_not
  
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
