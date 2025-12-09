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
# Sets the user’s chosen browser as the default browser. (See "$chosen_browser_id".)
# Specify the browser’s Bundle Identifier (CFBundleIdentifier) as the argument.
#
# To determine the bundle ID of an app:
#   mdls -name kMDItemCFBundleIdentifier -r /Applications/AppName.app
#     or
#   osascript -e 'id of app "App Name"'

report_start_phase_standard
report_action_taken "Set default browser to $chosen_browser_id"

# Path where the default-browser app is installed by its package installer
local path_to_installed_default_browser_utility="/opt/macadmins/bin/default-browser"

local browser_id_chrome="com.google.chrome"
local browser_id_safari="com.apple.safari"
local browser_id_firefox="org.mozilla.firefox"
local browser_id_brave="com.brave.Browser"

# Un-comment the line corresponding to the desired default browser
local chosen_browser_id="$browser_id_firefox"
# local chosen_browser_id="$browser_id_safari"
# local chosen_browser_id="$browser_id_brave"
# local chosen_browser_id="$browser_id_chrome"

"$path_to_installed_default_browser_utility" --identifier "$chosen_browser_id" ; success_or_not

report_end_phase_standard

}
