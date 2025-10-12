# This file assumes:
# - GENOMAC_HELPER_DIR is already set in the current shell to the absolute path of the directory 
#   containing helpers.sh.
# - GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH is set to the path at which the preset to be autoloaded is located.
# These environment variables must be defined by assign_environment_variables.sh

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_btt_settings() {

report_start_phase_standard
report_action_taken "Implement BetterTouchTool settings"

local domain="com.hegenberg.BetterTouchTool"

report_adjust_setting "Define preset location to ${GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH}"
defaults write ${domain} BTTAutoLoadPath "${GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH}" ; success_or_not

report_end_phase_standard

}
