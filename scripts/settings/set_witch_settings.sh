#!/usr/bin/env zsh

# DEBUG: Inconsequential change to advance the commit

conditionally_install_Witch_license_files() {
  report_start_phase_standard

  run_if_user_has_not_done "$PERM_WITCH_LICENSE_FILES_HAVE_BEEN_INSTALLED" \
    install_Witch_license_files \
    "Skipping installing license files for Witch, because this was done in the past"

  report_end_phase_standard
}

function install_Witch_license_files() {
  # To be run (a) as a bootstrap step on a pristine user or (b) after a change in the configuration
  # of license files for Many Tricks software, which can happen after (a) licensing a new Many Tricks
  # app (i.e., other than Witch) or (b) a future upgrade of the Witch license when a newer version of
  # Witch is released.
  #
  # This function expects to find all Many Tricks license files in the shared Dropbox folder:
  # ~/Dropbox/Preferences_common/Witch/LICENSE/Files_to_transfer
  
  report_start_phase_standard

  local source_subdirectory="Witch/LICENSE/Files_to_transfer"
  
  # Hint: GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${LOCAL_DROPBOX_DIRECTORY}/Preferences_common"
  local source_directory="${GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY}/${source_subdirectory}"

  local destination_directory="$HOME/Library/Application Support/Many Tricks/Licenses"

  report_action_taken "Copy Many Tricks license files from Dropbox to user’s Library"
  copy_resource_between_local_directories "$source_directory" "$destination_directory" ; success_or_not

  report_end_phase_standard
}

function set_witch_settings() {
  report_start_phase_standard

  local witch_plist_path
  witch_plist_path="${HOME}/Library/Application Support/Witch/Settings.plist"

  report_action_taken "Ensuring Witch’s Settings.plist exists"
  mkdir -p "${witch_plist_path:h}"
  if [[ ! -f "$witch_plist_path" ]]; then
    # Creates a no-content template .plist file
    "$PLISTBUDDY_PATH" -c "Save" "$witch_plist_path"
  fi
  success_or_not

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
