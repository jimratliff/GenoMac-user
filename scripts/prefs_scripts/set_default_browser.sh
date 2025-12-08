# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_default_browser() {

report_start_phase_standard

local default_browser_path="/opt/macadmins/bin/default-browser"
local browser_uti_chrome="com.google.chrome"
local browser_uti_safari="com.apple.safari"
local browser_uti_firefox="org.mozilla.firefox"

local chosen_browser_uti=browser_uti_firefox

report_action_taken "Set default browser to $chosen_browser_uti"
$default_browser_path --identifier "$chosen_browser_uti"

report_end_phase_standard

}
