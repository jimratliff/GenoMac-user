#!/bin/zsh

function install_btt_license_file() {
  # To be run only once per user to install the BetterTouchTool license file.
  # The BetterTouchTool license is stored in Dropbox. It needs to be:
  # (a) copied from that Dropbox location and 
  # (b) installed into the appropriate location of the user’s Library folder.
  
  report_start_phase_standard
  report_action_taken "Bootstrap-only installation of BetterTouchTool license file."

  local license_file_name="bettertouchtool.bttlicense"
  
  local source_subpath="BetterTouchTool/LICENSE/${license_file_name}"
  # Hint: GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${GENOMAC_USER_DROPBOX_DIRECTORY}/Preferences_common"
  local source_path="${GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY}/${source_subpath}"
  
  local destination_directory="$HOME/Library/Application Support/BetterTouchTool"
  local destination_path="${destination_directory}/${license_file_name}"

  report_action_taken "Copy BTT license file from Dropbox to Library"
  copy_resource_between_local_directories "$source_path" "$destination_path" ; success_or_not
  
  report_end_phase_standard
  
}
