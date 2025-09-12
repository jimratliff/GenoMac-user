# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function bootstrap_preview_app() {

# To be run only once per user to configure the initial toolbar for Preview.app.
# See the related, and corresponding, maintenance script: set_preview_settings.sh

report_start_phase_standard
report_action_taken "Bootstrap-only configuration of Preview.app’s toolbar"

local domain="com.apple.Preview"
local plist_path=$(sandboxed_plist_path_from_domain "$domain")
local toolbar_key="NSToolbar Configuration CommonToolbar_v5.1"

report_action_taken "Ensuring the plist for ${domain} exists."
ensure_plist_path_exists "${plist_path}"

# Preview: Reconfigure Toolbar
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
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:0' string goto_page" "$plist_path"
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:1' string form_filling" "$plist_path"
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:2' string previous_next" "$plist_path"
"$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:3' string search" "$plist_path"

report_action_taken "Killing Preview (metaphorically)."
killall Preview ; success_or_not

report_end_phase_standard

}
