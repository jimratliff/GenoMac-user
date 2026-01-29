#!/usr/bin/env zsh

function bootstrap_finder() {

  # To be run only once per user to configure (a) the initial toolbar and 
  # (b) default path for a Finder window.
  # See the related, and corresponding, maintenance script: set_finder_settings.sh
  
  report_start_phase_standard
  report_action_taken "Bootstrap-only configuration of Finder’s (a) toolbar and (b) default new-window path"
  
  local domain="com.apple.finder"
  local plist_path=$(legacy_plist_path_from_domain "$domain")
  local toolbar_key="NSToolbar Configuration Browser"
  
  report_action_taken "Ensuring the plist for ${domain} exists."
  ensure_plist_path_exists "${plist_path}"

  # Open new windows to HOME
  # This is intended for bootstrapping ONLY, not for enforcement
  report_adjust_setting "By default, new Finder window should open to user’s home directory"
  defaults write $domain NewWindowTarget -string "PfHm" ; success_or_not
  
  ############### Reconfigure Toolbar
  report_action_taken "Reconfigure Toolbar"
  # Ensure the parent dict exists (recreate it fresh so we're deterministic)
  "$PLISTBUDDY_PATH" -c "Delete '$toolbar_key'" "$plist_path" 2>/dev/null || true
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key' dict" "$plist_path"
  
  # Basic toolbar settings
  report_adjust_setting "Show Icon and text in toolbar"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Display Mode' integer 1" "$plist_path"
  report_adjust_setting "Small toolbar icons"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Icon Size Mode' integer 1" "$plist_path"
  report_adjust_setting "Show toolbar"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Is Shown' bool true" "$plist_path"
  # report_adjust_setting "Small/compact toolbar size" (This is probably deprecated)
  # "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Size Mode' integer 1" "$plist_path"
  
  # The toolbar items, in order
  # Other options:
  #  com.apple.finder.BACK — Back/Forward buttons
  #  com.apple.finder.SWCH — View mode switcher (icon/list/column/gallery)
  #  com.apple.finder.ARNG — Group/Sort options
  #  com.apple.finder.ACTN — Action menu (gear icon)
  #  com.apple.finder.SHAR — Share button
  #  com.apple.finder.EDIT — Edit tags
  #  com.apple.finder.SRCH — Search field
  #  NSToolbarFlexibleSpaceItem — Flexible space
  #  NSToolbarSpaceItem — Fixed space
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers' array" "$plist_path"
  "$PLISTBUDDY_PATH" -c "Add '$toolbar_key:TB Item Identifiers:0' string com.apple.finder.SRCH" "$plist_path"
  
  report_action_taken "Killing Finder (metaphorically)."
  killall Finder ; success_or_not
  
  report_end_phase_standard

}
