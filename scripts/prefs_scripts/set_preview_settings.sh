#!/bin/zsh

function set_preview_settings() {

  # Note: The toolbar for Preview.app is separately configured by bootstrap_preview_app.sh

  report_start_phase_standard
  report_action_taken "Implement Preview.app settings"
  
  local domain="com.apple.Preview"
  local plist_path=$(sandboxed_plist_path_from_domain "$domain")
  
  ensure_plist_path_exists "${plist_path}"
  
  # Remove user’s name from annotations
  report_adjust_setting "Remove user’s name from annotations"
  defaults write "${domain}" PVGeneralUseUserName -bool false ; success_or_not
  
  report_end_phase_standard

}
