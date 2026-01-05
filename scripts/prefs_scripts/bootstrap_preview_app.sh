#!/bin/zsh

function bootstrap_preview_app() {

  # To be run only once per user to configure the initial toolbar for Preview.app.
  # See the related, and corresponding, maintenance script: set_preview_settings.sh
  
  report_start_phase_standard
  report_action_taken "Bootstrap-only configuration of Preview.app’s toolbar"
  
  local domain="com.apple.Preview"
  local plist_path=$(sandboxed_plist_path_from_domain "$domain")
  local toolbar_key="NSToolbar Configuration CommonToolbar_v5.1"
  
  report_action_taken "Launching and quitting Preview to prepare the plist."
  launch_and_quit_app "$domain"
  sleep 2 # Give Preview plenty of time to quit before trying to modify its plist

  # The following is removed because unnecessary. Remove this code after full testing.
  # report_action_taken "Ensuring the plist for ${domain} exists."
  # ensure_plist_path_exists "${plist_path}"
  
  # Preview: Reconfigure Toolbar
  report_action_taken "Reconfigure Toolbar"
  # Ensure the parent dict exists (recreate it fresh so we're deterministic)
  "$PLISTBUDDY_PATH" -c "Delete '$toolbar_key'" "$plist_path" 2>/dev/null || true
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key' dict" "$plist_path"
  
  # Basic toolbar settings (match your sample: all 1)
  report_adjust_setting "Show Icon and text in toolbar"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Display Mode' integer 1" "$plist_path"
  report_adjust_setting "Small toolbar icons"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Icon Size Mode' integer 1" "$plist_path"
  report_adjust_setting "Show toolbar"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Is Shown' bool true" "$plist_path"
  report_adjust_setting "Small/compact toolbar size"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Size Mode' integer 1" "$plist_path"
  
  # The toolbar items, in order
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers' array" "$plist_path"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:0' string goto_page" "$plist_path"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:1' string form_filling" "$plist_path"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:2' string scale" "$plist_path"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:3' string search" "$plist_path"
  
  report_end_phase_standard

}
