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

function set_notifications_settings() {

report_start_phase_standard


report_action_taken "Stops notifications from Tips app"
local domain="com.apple.Notifications-Settings.extension"
local plist_path=$(legacy_plist_path_from_domain "$domain")
local notification_key="lastActiveNotificationStyle"

ensure_plist_path_exists "${plist_path}"

report_adjust_setting "Tips app: Stop notifications"

# Ensure the parent dict exists, then set the Tips notification setting
"$PLISTBUDDY_PATH" -c "Add '$notification_key' dict" "$plist_path" 2>/dev/null || true
"$PLISTBUDDY_PATH" -c "Set '$notification_key:com.apple.tips' 2" "$plist_path" 2>/dev/null || \
    "$PLISTBUDDY_PATH" -c "Add '$notification_key:com.apple.tips' integer 2" "$plist_path"
success_or_not

report_end_phase_standard

}
