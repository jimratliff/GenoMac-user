# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

# COMMON_PATH_FOR_APPS="/Applications/"
# APPS_FOR_DOCK=(
#   "System Settings.app"
#   "1Password.app"
#   "Antnotes.app"
#   "TextExpander.app"
#   "Raindrop.io.app"
#   "Obsidian.app"
#   "Utilities/Activity Monitor.app"
#   "Utilities/Terminal.app"
#   "iTerm.app"
# )

# Define Dock app items
# Each app in APPS_FOR_DOCK is referenced by its path relative to /Applications
COMMON_PATH_FOR_APPS="/Applications/"
APPS_FOR_DOCK=(
  "/System/Applications/System Settings.app"
  "Applications/1Password.app"
  "Applications/Antnotes.app"
  "Applications/TextExpander.app"
  "Applications/Raindrop.io.app"
  "Applications/Obsidian.app"
  "/System/Applications/Utilities/Activity Monitor.app"
  "/System/Applications/Utilities/Terminal.app"
  "Applications/iTerm.app"
)

function dock_app_entry() {
  # Function takes single argument of the full path of the app to add to the Dock.
  printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>', "$1"
}

function bootstrap_dock() {
# To be run only once per user to initially populate the persistent apps of the Dock.

report_start_phase_standard
report_action_taken "Bootstrap-only initial population of the Dock."

local domain="com.apple.dock"
plist_path=$(legacy_plist_path_from_domain $domain")

report_action_taken "Ensure plist for Dock exists at $plist_path"
ensure_plist_path_exists "${plist_path}" ; success_or_not

local dock_persistent_apps_key="persistent-apps"

# In this implementation, the 'persistent-others' key is not used.
# local dock_ephemeral_files_folders_key="persistent-others"

# Because the Dock always runs, its plist necessarily exists. 
# Thus, there is no need to ensure its plist exists.

report_action_taken "Remove all persistent apps from Dock in preparation for repopulation" 
defaults delete $domain $dock_persistent_apps_key ; success_or_not

# Policy: Leave the non-persistent part of the Dock alone.
# report_adjust_setting "Delete file and folder entries from existing Dock"
# defaults delete $domain $dock_ephemeral_files_folders_key ; success_or_not

# Initialize the array
report_action_taken "Initialize persistent-apps array" 
defaults write "$domain" "$dock_persistent_apps_key" -array ; success_or_not

for app in "${APPS_FOR_DOCK[@]}"; do
  report_adjust_setting "App $app added to Dock"
  # app_path="${COMMON_PATH_FOR_APPS}${app}"
  app_path="${app}"
  dock_item="$(dock_app_entry $app_path)"
  defaults write $domain $dock_persistent_apps_key -array-add $dock_item  ; success_or_not
done

report_action_taken "Killing Dock (metaphorically)."
killall Dock 2>/dev/null || true ; success_or_not

report_end_phase_standard
}
