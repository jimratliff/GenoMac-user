#!/usr/bin/env zsh

# Define Dock persistent-app items
#   Does not alter anything for non-persistent apps.
#   Does not alter the defaults for the Downloads folder and the Trash Can on the furthest right-hand side of the Dock.

function bootstrap_dock() {
  # To be run only once per user to initially populate the persistent apps of the Dock.
  # It removes all persistent apps prior to repopulating the persistent apps.
  
  report_start_phase_standard
  local -a apps_for_dock

  # Add desired apps to Dock
  apps_for_dock=( "${(@f)$(define_apps_for_dock)}" )
  bootstrap_dock_given_apps_for_dock "${apps_for_dock[@]}"

  # Add designated directory of Finder alias files to Dock
  create_directory_for_aliases_for_Dock
  add_designated_directory_of_Finder_alias_files_to_Dock
  
  report_end_phase_standard
}

function bootstrap_dock_given_apps_for_dock() {
  # Constructs Dock arrangement from supplied array apps_for_dock.
  # Empties app side of Dock. Leaves document side (persistent-others) of Dock alone.
  
  report_start_phase_standard

  local -a apps_for_dock=("$@")
  
  report_action_taken "Bootstrap-only initial population of the Dock."

  local dock_item
  local domain="com.apple.dock"
  
  local plist_path
  plist_path="$(legacy_plist_path_from_domain "$domain")"
  
  report_action_taken_to_log "Ensure plist for Dock exists at $plist_path"
  ensure_plist_path_exists "${plist_path}" ; success_or_not
  
  local dock_persistent_apps_key="persistent-apps"
  
  report_action_taken_to_log "Remove all persistent apps from Dock in preparation for repopulation" 
  defaults delete "$domain" "$dock_persistent_apps_key" ; success_or_not
  kill_the_dock_metaphorically
  
  # Initialize the array
  report_action_taken_to_log "Initialize persistent-apps array" 
  defaults write "$domain" "$dock_persistent_apps_key" -array ; success_or_not
  
  for app in "${apps_for_dock[@]}"; do
    report_adjust_setting "App $app added to Dock"
    dock_item="$(dock_app_entry $app)"
    defaults write "$domain" "$dock_persistent_apps_key" -array-add "$dock_item" ; success_or_not
  done
  
  kill_the_dock_metaphorically
  
  report_end_phase_standard
}

function add_designated_directory_of_Finder_alias_files_to_Dock() {
  # Adds the designated directory ($DIRECTORY_OF_ALIASES_FOR_DOCK) of Finder alias files to Dock.
  
  report_start_phase_standard
  local already_present dock_item
  local domain="com.apple.dock"
  local file_url
  
  file_url="$(convert_filesystem_path_to_file_url "$DIRECTORY_OF_ALIASES_FOR_DOCK")"
  file_url="${file_url%/}/"

  already_present="$(dock_persistent_others_contains_file_url "$file_url")"

  if [[ "$already_present" == "true" ]]; then
    report_to_log "Skipping adding designated directory of Finder alias files to Dock, because that directory is already in the Dock."
    report_end_phase_standard
    return 0
  fi

  dock_item="$(dock_directory_entry "$file_url")"

  report_action_taken "Add aliases-for-Dock directory to the Dock"
  defaults write $domain persistent-others -array-add "$dock_item" ; success_or_not
  
  report_end_phase_standard
}

function define_apps_for_dock() {
  # Compile and order apps to populate the Dock depending on user’s attributes.
  #
  # Each app in apps_for_dock is referenced by its full path.
  # NOTE, IN PARTICULAR, for Apple’s own apps:
  # - Except for Safari, an Apple app (a) *appears* to live in /Applications (or /Applications/Utilities)
  #   but in fact (b) it actually lives in /System/Applications (or, respectively, /System/Applications/Utilities).
  # - It is necessary to specify an Apple app by its *actual* path, not its apparent path.
  # - Safari is exceptional:
  #   - /Applications/Safari.app is symlinked to /System/Cryptexes/App/System/Applications/Safari.app
  #   - Presumably that is the path that must be specified to add Safari to the Dock, though I haven’t tested it (but
  #     have seen evidence to support this).
  
  report_start_phase_standard

  # Define actual paths to apps: Apple
  local actual_path_to_app_Activity_Monitor="/System/Applications/Utilities/Activity Monitor.app"
  local actual_path_to_app_Disk_Utility="/System/Applications/Utilities/Disk Utility.app"
  local actual_path_to_app_Mail_app="/System/Applications/Mail.app"
  local actual_path_to_app_Safari="/System/Cryptexes/App/System/Applications/Safari.app"
  local actual_path_to_app_System_Settings="/System/Applications/System Settings.app"
  local actual_path_to_app_Terminal="/System/Applications/Utilities/Terminal.app"
  
  # Define actual paths to apps: non-Apple
  local actual_path_to_app_1Password="/Applications/1Password.app"
  local actual_path_to_app_Helium="/Applications/Helium.app"
  local actual_path_to_app_HIARCS_Chess_Explorer_Pro="/Applications/HIARCS Chess Explorer Pro.app"
  local actual_path_to_app_iTerm="/Applications/iTerm.app"
  local actual_path_to_app_Microsoft_Word="/Applications/Microsoft Word.app"
  local actual_path_to_app_Obsidian="/Applications/Obsidian.app"
  local actual_path_to_app_Raindrop_io="/Applications/Raindrop.io.app"
  local actual_path_to_app_Tower="/Applications/Tower.app"
  local actual_path_to_app_Waterfox="/Applications/Waterfox.app"
  local actual_path_to_app_Zed="/Applications/Zed.app"

  ############### Construct apps_for_dock
  
  # 1Password is unconditional
  local -a apps_for_dock=(
    "$actual_path_to_app_1Password"
  )

  # Mail.app
  if test_genomac_user_state "$SESH_APPLE_MAIL_APP_USER_WANTS_IT"; then
    apps_for_dock+=( "$actual_path_to_app_Mail_app" )
  fi
  
  # Safari is only browser in Dock for barebones; otherwise Waterfox and Helium
  # (which empirically rise and fall together, adjacent in the Dock)
  if test_genomac_user_state "$SESH_USER_WANTS_ONLY_BAREBONES_CONFIG"; then
    apps_for_dock+=( "$actual_path_to_app_Safari" )
  else
    apps_for_dock+=( 
      "$actual_path_to_app_Waterfox" 
      "$actual_path_to_app_Helium"
    )
  fi

  # Raindrop.io
  if test_genomac_user_state "$SESH_RAINDROP_IO_USER_WANTS_IT"; then
    apps_for_dock+=( "$actual_path_to_app_Raindrop_io" )
  fi

  # Obsidian
  if test_genomac_user_state "$SESH_OBSIDIAN_USER_WANTS_IT"; then
    apps_for_dock+=( "$actual_path_to_app_Obsidian" )
  fi

  # Microsoft Word
  if test_genomac_user_state "$SESH_MICROSOFT_WORD_USER_WANTS_IT"; then
    apps_for_dock+=( "$actual_path_to_app_Microsoft_Word" )
  fi

  # HIARCS Chess Explorer Pro
  if test_genomac_user_state "$SESH_HIARCS_CHESS_EXPLORER_PRO_USER_WANTS_IT"; then
    apps_for_dock+=( "$actual_path_to_app_HIARCS_Chess_Explorer_Pro" )
  fi

  # iTerm is unconditional:
  # Needed by every GenoMac-configured user, even non-developers in order to run GenoMac-user
  apps_for_dock+=( "$actual_path_to_app_iTerm" )

  # Zed and Tower
  if test_genomac_user_state "$SESH_USER_IS_A_DEVELOPER"; then
    apps_for_dock+=( 
      "$actual_path_to_app_Zed"
      "$actual_path_to_app_Tower"
    )
  fi

  # System Settings is unconditional
  apps_for_dock+=( "$actual_path_to_app_System_Settings" )

  # Activity Monitor
  if test_genomac_user_state "$SESH_USER_IS_A_DEVELOPER" || 
     test_genomac_user_state "$SESH_USER_IS_A_MAC_ADMIN"
  then
    apps_for_dock+=( "$actual_path_to_app_Activity_Monitor" )
  fi
  
  # Disk Utility
  if test_genomac_user_state "$SESH_USER_IS_A_MAC_ADMIN" || 
     test_genomac_user_state "$SESH_USER_IS_AN_ACCOUNT_SWITCHER"
  then
    apps_for_dock+=( "$actual_path_to_app_Disk_Utility" )
  fi

  # Return array by printing one array element per line.
  print -r -l -- "${apps_for_dock[@]}"

  report_end_phase_standard
}

function dock_app_entry() {
  # Function takes single argument of the full path of the app to add to the Dock.
  # Outputs the dictionary entry for this app’s tile, inserting the supplied argument into `_CFURLString`.
  printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' "$1"
}

function kill_the_dock_metaphorically() {
  report_start_phase_standard
  
  report_action_taken_to_log "Killing Dock (metaphorically)."
  killall Dock 2>/dev/null || true ; success_or_not
  
  report_end_phase_standard
}

function dock_persistent_others_contains_file_url() {
  # Outputs 'true' or 'false' if supplied file URL already exists in the Dock.
  report_start_phase_standard
  local file_url="$1"

  defaults export com.apple.dock - |
    plutil -convert json -o - - |
    jq -r --arg url "$file_url" '
      any(
        .["persistent-others"][]?;
        .["tile-data"]["file-data"]["_CFURLString"] == $url
      )
    '
  report_end_phase_standard
}

function dock_directory_entry() {
  # Takes an encoded file URL for the directory to add to the Dock.
  # Outputs the XML dictionary for the directory’s tile.
  
  report_start_phase_standard

  local file_url="${1:?Expected an encoded directory file URL}"
  
  local escaped_url
  
  escaped_url="$(jq -nr --arg url "$file_url" '$url | @html')"

  printf '<dict>
    <key>tile-data</key><dict>
      <key>file-data</key><dict>
        <key>_CFURLString</key><string>%s</string>
        <key>_CFURLStringType</key><integer>15</integer>
      </dict>
    </dict>
    <key>tile-type</key><string>directory-tile</string>
  </dict>\n' "$escaped_url"
  
  report_end_phase_standard
}

