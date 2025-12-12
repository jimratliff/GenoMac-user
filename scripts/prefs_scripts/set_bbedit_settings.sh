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

function set_bbedit_settings() {

report_start_phase_standard
report_action_taken "Implement BBEdit settings"

local domain="com.barebones.bbedit"

report_adjust_setting "Set: Do NOT prefer shared window for New and Open"
defaults write ${domain} NewAndOpenPrefersSharedWindow -bool false ; success_or_not

report_adjust_setting "Set: DO soft-wrap text"
defaults write ${domain} EditorSoftWrap -bool true ; success_or_not

report_adjust_setting "Set: Soft-wrap text to WINDOW WIDTH"
defaults write ${domain} SoftWrapStyle -int 2 ; success_or_not

report_adjust_setting "Set: Display full path of files in “Open Recent” Items"
defaults write ${domain} Display_FullPathInRecentMenu -bool true ; success_or_not

report_adjust_setting "Set: When BBEdit becomes active, do nothing (don’t open a new doc)"
defaults write ${domain} StartupAndResumeAction -int 1 ; success_or_not

report_end_phase_standard

}
