# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function install_btt_license_file() {
  # To be run only once per user to install the BetterTouchTool license file.
  # The BetterTouchTool license is stored in Dropbox. It needs to be:
  # (a) copied from that Dropbox location and 
  # (b) installed into the appropriate location of the user’s Library folder.
  
  report_start_phase_standard
  report_action_taken "Bootstrap-only installation of BetterTouchTool license file."

  local license_file_name="bettertouchtool.bttlicense"
  
  local source_subpath="BetterTouchTool/LICENSE/${license_file_name}"
  local source_path="${GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY}/${source_subpath}"
  
  local destination_directory="$HOME/Library/Application Support/BetterTouchTool"
  local destination_path="${destination_directory}/${license_file_name}"

  report_action_taken "Copy BTT license file from Dropbox to Library"
  copy_resource_between_local_directories "$source_path" "$destination_path" ; success_or_not
  
  report_end_phase_standard
}
