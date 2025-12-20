# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_microsoft_office_suite_wide_settings() {

report_start_phase_standard

local domain="com.microsoft.Word"

report_action_taken "Set VERY limited Microsoft Word preferences"

report_adjust_setting "Ribbon: Show group titles"
defaults write "${domain}" OUIRibbonShowGroupTitles -bool true ; success_or_not

report_end_phase_standard

}
