# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Define Dock app items

# Each app in APPS_FOR_DOCK is referenced by its path relative to /Applications
COMMON_PATH_FOR_APPS="/Applications/"
APPS_FOR_DOCK=\
  "System%20Settings.app/"
  "1Password" \
  "Antnotes" \
  "TextExpander" \
  "Raindrop.io"
  "Obsidian"
  "Utilities/Activity%20Monitor"
  "Utilities/Terminal.app/"
  "iTerm.app/"

function dock_app_entry() {
  # Function takes single argument of the full path of the app to add to the Dock.
  printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>', "$1"
}

function bootstrap_dock() {
# To be run only once per user to initially populate the persistent apps of the Dock.

report_start_phase_standard
report_action_taken "Bootstrap-only initial population of the Dock."

local domain="com.apple.dock"
local dock_persistent_apps_key="persistent-apps"
# local dock_ephemeral_files_folders_key="persistent-others"

# Because the Dock always runs, its plist necessarily exists. 
# Thus, there is no need to ensure its plist exists.

report_action_taken "Remove all persistent apps from Dock in preparation for repopulation" 
defaults delete $domain $dock_persistent_apps_key ; success_or_not
# report_adjust_setting "Delete file and folder entries from existing Dock"
# defaults delete $domain $dock_ephemeral_files_folders_key ; success_or_not

for app in $APPS_FOR_DOCK; do
  app_path=${COMMON_PATH_FOR_APPS}"$app"
  dock_item="$(dock_app_entry $app_path"
  defaults write $domain $dock_persistent_apps_key -array-add $dock_item

report_action_taken "Killing Dock (metaphorically)."
killall Dock ; success_or_not

report_end_phase_standard
}
