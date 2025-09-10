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
local plist_path=$(function sandboxed_plist_path_from_domain() { "$domain")

ensure_plist_path_exists "${plist_path}"

# Remove user’s name from annotations
report_adjust_setting "Remove user’s name from annotations"
defaults write "${domain}" PVGeneralUseUserName -bool false ; success_or_not

# Preview: Reconfigure Toolbar
report_action_taken "Reconfigure Toolbar"
# Ensure the parent dict exists (recreate it fresh so we're deterministic)
$PLISTBUDDY_PATH -c "Delete :'$key'" "$plist_path" 2>/dev/null || true
$PLISTBUDDY_PATH -c "Add :'$key' dict" "$plist_path"

# Basic toolbar settings (match your sample: all 1)
$PLISTBUDDY_PATH -c "Add :'$key':'TB Display Mode' integer 1" "$plist_path"
$PLISTBUDDY_PATH -c "Add :'$key':'TB Icon Size Mode' integer 1" "$plist_path"
$PLISTBUDDY_PATH -c "Add :'$key':'TB Is Shown' integer 1" "$plist_path"
$PLISTBUDDY_PATH -c "Add :'$key':'TB Size Mode' integer 1" "$plist_path"

# The toolbar items, in order
$PLISTBUDDY_PATH -c "Add :'$key':'TB Item Identifiers' array" "$plist_path"
$PLISTBUDDY_PATH -c "Add :'$key':'TB Item Identifiers':0 string 'goto_page'" "$plist_path"
$PLISTBUDDY_PATH -c "Add :'$key':'TB Item Identifiers':1 string 'form_filling'" "$plist_path"
$PLISTBUDDY_PATH -c "Add :'$key':'TB Item Identifiers':2 string 'previous_next'" "$plist_path"
$PLISTBUDDY_PATH -c "Add :'$key':'TB Item Identifiers':3 string 'search'" "$plist_path"


report_end_phase_standard

}
