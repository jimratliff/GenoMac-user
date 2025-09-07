# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_diskutility_settings() {

report_start_phase_standard

domain="write com.apple.DiskUtility"

ensure_plist_exists "${domain}"

# Launch and quit DiskUtility in order that it will have preferences to modify.
# report_action_taken "Launch and quit DiskUtility in order that it will have preferences to modify"
# open -b com.apple.DiskUtility # By bundle ID (more reliable than `open -a` by display name)
# sleep 2
# osascript -e 'quit app "Disk Utility"';success_or_not

# DiskUtility: Show all devices in sidebar
report_adjust_setting "DiskUtility: Show all devices in sidebar"
defaults write ${domain} SidebarShowAllDevices -bool true;success_or_not

report_end_phase_standard

}
