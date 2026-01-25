#!/usr/bin/env zsh

function set_notifications_settings() {

  report_start_phase_standard
  
  report_action_taken "Stops notifications from Tips app"
  local domain="com.apple.Notifications-Settings.extension"
  local plist_path=$(legacy_plist_path_from_domain "$domain")
  local notification_key="lastActiveNotificationStyle"
  
  ensure_plist_path_exists "${plist_path}"

  "$PLISTBUDDY_PATH" -c "Add '$notification_key' dict" "$plist_path" 2>/dev/null || true
  "$PLISTBUDDY_PATH" -c "Set '$notification_key:com.apple.tips' 2" "$plist_path" 2>/dev/null || \
      "$PLISTBUDDY_PATH" -c "Add '$notification_key:com.apple.tips' integer 2" "$plist_path"
  success_or_not
  
  report_end_phase_standard

}
