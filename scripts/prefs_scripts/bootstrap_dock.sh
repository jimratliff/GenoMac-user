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

"Applications/1Password" \
"Applications/Antnotes" \
"Applications/TextExpander" \


function dock_app_entry() {
    printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>', "$1"
}

function bootstrap_dock() {

# To be run only once per user to initially populate the Dock.

report_start_phase_standard
report_action_taken "Bootstrap-only initial population of the Dock."

local domain="com.apple.dock"
local plist_path=$(legacy_plist_path_from_domain "$domain")
local dock_population_apps_key="persistent-apps"
# local dock_population_files_folders_key="persistent-others"

# Because the Dock always runs, its plist necessarily exists. 
# Thus, there is no need to ensure its plist exists.

# Destroy the default Dock in preparation for repopulating it
# report_action_taken "Destroy existing Dock in preparation for repopulation"
report_action_taken "Delete app entries from existing Dock in preparation for repopulation" 
defaults delete $domain $dock_population_apps_key ; success_or_not
# report_adjust_setting "Delete file and folder entries from existing Dock"
# defaults delete $domain $dock_population_files_folders_key ; success_or_not

# Finder: Reconfigure Toolbar
report_action_taken "Reconfigure Toolbar"
# Ensure the parent dict exists (recreate it fresh so we're deterministic)
"$PLISTBUDDY_PATH" -c "Delete '$toolbar_key'" "$plist_path" 2>/dev/null || true
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key' dict" "$plist_path"

# Basic toolbar settings (match your sample: all 1)
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Display Mode' integer 1" "$plist_path"
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Icon Size Mode' integer 1" "$plist_path"
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Is Shown' bool true" "$plist_path"
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Size Mode' integer 1" "$plist_path"

# The toolbar items, in order
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers' array" "$plist_path"
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:0' string com.apple.finder.SRCH" "$plist_path"

report_action_taken "Killing Dock (metaphorically)."
killall Dock ; success_or_not

report_end_phase_standard

}
