# This file assumes:
# - GENOMAC_HELPER_DIR is already set in the current shell to the absolute path of the directory 
#   containing helpers.sh.
# - PLISTBUDDY_PATH
# These environment variables must be defined by assign_environment_variables.sh

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_preview_settings() {

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
