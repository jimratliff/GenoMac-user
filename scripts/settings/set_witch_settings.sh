#!/usr/bin/env zsh

conditionally_install_Witch_license_files() {
  report_start_phase_standard

  run_if_user_has_not_done "$PERM_WITCH_LICENSE_FILES_HAVE_BEEN_INSTALLED" \
    install_Witch_license_files \
    "Skipping installing license files for Witch, because this was done in the past"

  report_end_phase_standard
}

conditionally_interactive_enable_Witch() {
  report_start_phase_standard

  run_if_user_has_not_done "$PERM_WITCH_HAS_BEEN_ENABLED" \
    interactive_enable_witch_for_user \
    "Skipping enabling Witch, because this was done for this user in the past"

  report_end_phase_standard
}

function interactive_enable_witch_for_user() {
  report_start_phase_standard
  
  report "Time to activate Witch! I’ll launch its preference pane, and open a window with instructions"

  # HINT: $WITCH_PATH_TO_USER_PREFPANE: ~/Library/PreferencePanes/Witch.prefPane
	
  launch_app_and_prompt_user_to_act \
    --no-app \
    --open "${WITCH_PATH_TO_USER_PREFPANE}" \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Witch_how_to_enable.md" \
    "Follow the instructions in the Quick Look window to enable the Witch preference pane"

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

  report_action_taken "Copy Many Tricks license files from Dropbox to user’s Library${NEWLINE}${source_directory} → ${destination_directory}"
  copy_resource_between_local_directories "$source_directory" "$destination_directory"

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
  trap "rm -f '$tempfile_containing_action_configurations'" EXIT

  
  report_action_taken "Delete 'Action Configurations' key if it exists"
  # Delete only if key already exists (e.g., on a re-run)
  "$PLISTBUDDY_PATH" -c "Print 'Action Configurations'" "$witch_plist_path" &>/dev/null \
      && "$PLISTBUDDY_PATH" -c "Delete 'Action Configurations'" "$witch_plist_path"
  success_or_not

  report_action_taken "Writing new configurations to Witch’s Settings.plist"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations' array" "$witch_plist_path"

  # First action dict
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0' dict" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Action Type' integer 0" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Hot Key\: Standard' dict" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Hot Key\: Standard:Key Code' integer 48" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Hot Key\: Standard:Modifiers' integer 1573160" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Hot Key\: Standard:Visual Representation' string '⌥⌘⇥'" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Hot Key\: Standard\: Trigger Menu' bool true" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Menu' bool true" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Orientation' integer 0" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Placeholder' bool false" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Sort Order' integer 5" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Sort Order\: Invert' bool false" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Spaces' bool true" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Tabs' bool true" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Tabs\: Frontmost Window Only' bool false" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:0:Tabs\: Mode' integer 1" "$witch_plist_path"

  # Second action dict
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1' dict" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Hot Key\: Standard' dict" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Hot Key\: Standard:Key Code' integer 48" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Hot Key\: Standard:Modifiers' integer 524576" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Hot Key\: Standard:Visual Representation' string '⌥⇥'" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Menu' bool false" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Orientation' integer 0" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Placeholder' bool false" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Placeholder\: Mode' integer 1" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Sort Order' integer 5" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Sort Order\: Invert' bool false" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Spaces' bool false" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Tabs' bool true" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Tabs\: Frontmost Window Only' bool false" "$witch_plist_path"
  "$PLISTBUDDY_PATH" -c "Add 'Action Configurations:1:Tabs\: Mode' integer 2" "$witch_plist_path"
      
  set_or_add_plist_value 'Show Search Field' bool false "$witch_plist_path"
  set_or_add_plist_value 'Spring-Load'       bool true  "$witch_plist_path"

  success_or_not

  report_action_taken "Removing tempfile"
  rm "${tempfile_containing_action_configurations}" ; success_or_not
  
  report_end_phase_standard
}
