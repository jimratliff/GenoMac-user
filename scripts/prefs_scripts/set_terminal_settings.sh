# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_terminal_settings() {

report_start_phase_standard

report_action_taken "Give the Terminal a teeny bit of style, even though we will soon abandon it"
report_adjust_setting "Terminal: default for new windows: “Man Page”";success_or_not
defaults write com.apple.Terminal "Default Window Settings" -string "Man Page"
report_adjust_setting "Terminal: default for starting windows: “Man Page”";success_or_not
defaults write com.apple.Terminal "Startup Window Settings" -string "Man Page"

report_end_phase_standard

}
