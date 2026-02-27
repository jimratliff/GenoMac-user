#!/usr/bin/env zsh

function conditionally_configure_witch() {
  report_start_phase_standard
  
  run_if_user_has_not_done "$PERM_WITCH_SETTINGS_HAVE_BEEN_IMPLEMENTED" \
    set_witch_settings \
    "Skipping setting preferences for Witch, because this was done in the past"
  
  report_end_phase_standard
}

function set_witch_settings() {
  report_start_phase_standard

  report_action_taken "Launching and quitting Witch to prepare the plist."
  launch_and_quit_app "$BUNDLE_ID_WITCH"

  local witch_plist_path
  witch_plist_path="${HOME}/Library/Application Support/Witch/Settings.plist"

  report_action_taken "Creating tempfile containing desired Witch action configurations"
  local tempfile_containing_action_configurations
  tempfile_containing_action_configurations=$(create_temp_file_with_witch_action_configurations) ; success_or_not

  report_action_taken "Writing new configurations to Witch’s Settings.plist"
  "$PLISTBUDDY_PATH" \
    -c "Delete 'Action Configurations'" \
    -c "Import 'Action Configurations' $tempfile_containing_action_configurations" \
    -c "Set 'Show Search Field' false" \
    -c "Set 'Spring-Load' true" \
    "$witch_plist_path"
  success_or_not

  report_action_taken "Removing tempfile"
  rm "${tempfile_containing_action_configurations}" ; success_or_not
  
  report_end_phase_standard
}

function create_temp_file_with_witch_action_configurations() {
  # Create a temp file into which to write a .plist that contains the entire
  # desired `Action Configurations` key as an array.

  local tmpfile
  tmpfile=$(mktemp /tmp/witch_action_configs.XXXXXX.plist)
  cat > "$tmpfile" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
    <dict>
        <key>Action Type</key>
        <integer>0</integer>
        <key>Hot Key: Standard</key>
        <dict>
            <key>Key Code</key>
            <integer>48</integer>
            <key>Modifiers</key>
            <integer>1573160</integer>
            <key>Visual Representation</key>
            <string>⌥⌘⇥</string>
        </dict>
        <key>Hot Key: Standard: Trigger Menu</key>
        <true/>
        <key>Menu</key>
        <true/>
        <key>Orientation</key>
        <integer>0</integer>
        <key>Placeholder</key>
        <false/>
        <key>Sort Order</key>
        <integer>5</integer>
        <key>Sort Order: Invert</key>
        <false/>
        <key>Spaces</key>
        <true/>
        <key>Tabs</key>
        <true/>
        <key>Tabs: Frontmost Window Only</key>
        <false/>
        <key>Tabs: Mode</key>
        <integer>1</integer>
    </dict>
    <dict>
        <key>Hot Key: Standard</key>
        <dict>
            <key>Key Code</key>
            <integer>48</integer>
            <key>Modifiers</key>
            <integer>524576</integer>
            <key>Visual Representation</key>
            <string>⌥⇥</string>
        </dict>
        <key>Menu</key>
        <false/>
        <key>Orientation</key>
        <integer>0</integer>
        <key>Placeholder</key>
        <false/>
        <key>Placeholder: Mode</key>
        <integer>1</integer>
        <key>Sort Order</key>
        <integer>5</integer>
        <key>Sort Order: Invert</key>
        <false/>
        <key>Spaces</key>
        <false/>
        <key>Tabs</key>
        <true/>
        <key>Tabs: Frontmost Window Only</key>
        <false/>
        <key>Tabs: Mode</key>
        <integer>2</integer>
    </dict>
</array>
</plist>
EOF

  # Return the path of the temp file, to be captured via `$()` in the caller
  # `print --` is preferred over `echo` in Zshell for returning values from functions,
  # since it won’t misinterpret strings that begin with `-` as flags.
  print -- "$tmpfile"
  
}


