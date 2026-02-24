#!/usr/bin/env zsh

conditionally_configure_bettertouchtool() {
  report_start_phase_standard
  
  run_if_user_has_not_done \
    "$PERM_BTT_HAS_BEEN_CONFIGURED" \
    set_btt_settings_and_install_license \
    "Skipping configuring BetterTouchTool because it’s been done in the past"
    
  report_end_phase_standard
}

function set_btt_settings_and_install_license() {
  report_start_phase_standard
  
  set_btt_settings
  install_btt_license_file
  
  report_end_phase_standard
}

function set_btt_settings() {

  # As of October 2025, BTT has no reliable method for syncing its “preset” configuration 
  # across users/Macs (although the promised delivery of this feature is overdue).
  # 
  # Instead, an established preset file is deployed by GenoMac-user to a location where BTT 
  # will detect it when BTT launches and import it for use. By default, BTT expects the 
  # preset-to-be-autoloaded to exist at `~/.btt_autoload_preset.json`. However, we override 
  # this location to be `~/.config/BetterTouchTool/Default_preset.json` using the syntax 
  # `defaults write com.hegenberg.BetterTouchTool BTTAutoLoadPath "~/somepath"`.
  # 
  # This deployment is accomplished by GenoMac-user’s dotfile-stowing process. Hence, no 
  # separate operation need be performed here to implement this (given that the 
  # dotfile-stowing process is already part of the standard GenoMac-user workflow).
  # 
  # It is expected that BTT’s standard preset will be very stable in the sense of rarely 
  # changing. If it *does* change, see the section “Appendix: What to do when you change 
  # the BetterTouchTool preset” of the README of this repository.
  
  report_start_phase_standard
  
  report_action_taken "Implement BetterTouchTool settings"
  
  local domain="com.hegenberg.BetterTouchTool"
  
  report_adjust_setting "Define preset location to ${GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH}"
  defaults write ${domain} BTTAutoLoadPath "${GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH}" ; success_or_not
  
  report_end_phase_standard
}

function install_btt_license_file() {
  # To be run only once per user to install the BetterTouchTool license file.
  # The BetterTouchTool license is stored in Dropbox. It needs to be:
  # (a) copied from that Dropbox location and 
  # (b) installed into the appropriate location of the user’s Library folder.
  
  report_start_phase_standard
  
  report_action_taken "Bootstrap-only installation of BetterTouchTool license file."

  local license_file_name="bettertouchtool.bttlicense"
  
  local source_subpath="BetterTouchTool/LICENSE/${license_file_name}"
  # Hint: GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${LOCAL_DROPBOX_DIRECTORY}/Preferences_common"
  local source_path="${GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY}/${source_subpath}"
  
  local destination_directory="$HOME/Library/Application Support/BetterTouchTool"
  local destination_path="${destination_directory}/${license_file_name}"

  report_action_taken "Copy BTT license file from Dropbox to Library"
  copy_resource_between_local_directories "$source_path" "$destination_path" ; success_or_not
  
  report_end_phase_standard
}
