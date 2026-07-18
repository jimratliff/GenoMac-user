#!/usr/bin/env zsh

# Define Dock persistent-app items
#   Does not alter anything for non-persistent apps.
#   Does not alter the defaults for the Downloads folder and the Trash Can on the furthest right-hand side of the Dock.

function bootstrap_dock() {
  # To be run only once per user to initially populate the persistent apps of the Dock.
  # It removes all persistent apps prior to repopulating the persistent apps.
  
  report_start_phase_standard
  local -a apps_for_dock

  apps_for_dock=( "${(@f)$(define_apps_for_dock)}" )
  bootstrap_dock_given_apps_for_dock "${apps_for_dock[@]}"
  
  report_end_phase_standard
}

function bootstrap_dock_given_apps_for_dock() {
  # Constructs Dock arrangement from supplied array apps_for_dock
  
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
  
  # In this implementation, the 'persistent-others' key is not used.
  # local dock_ephemeral_files_folders_key="persistent-others"
  # Policy: Leave the non-persistent part of the Dock alone.
  # report_adjust_setting "Delete file and folder entries from existing Dock"
  # defaults delete $domain $dock_ephemeral_files_folders_key ; success_or_not
  
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

  # By default, 1Password appears as the first item on each user’s Dock.
  local -a apps_for_dock=(
    "$actual_path_to_app_1Password"
  )

  # Compiles attributes that will guide Dock arrangement

  local -i is_bare_bones=0 # false
  if test_genomac_user_state "$SESH_USER_WANTS_ONLY_BAREBONES_CONFIG"; then
    is_bare_bones=1
  fi

  local -i is_chessplayer=0 # false
  if test_genomac_user_state "$USER_ATTRIBUTE_CHESSPLAYER"; then
    is_chessplayer=1
  fi

  local -i is_developer=0 # false
  if test_genomac_user_state "$USER_ATTRIBUTE_DEVELOPER" || 
     test_genomac_user_state "$USER_ATTRIBUTE_GENOMAC_DEVELOPER"
  then
    is_developer=1
  fi

  local -i is_emailer=0 # false
  if test_genomac_user_state "$USER_ATTRIBUTE_EMAILER"; then
    is_emailer=1
  fi

  local -i is_mac_admin=0 # false
  if test_genomac_user_state "$USER_ATTRIBUTE_MAC_ADMIN"; then
    is_mac_admin=1
  fi

  local -i is_switcher=0 # false
  if test_genomac_user_state "$USER_ATTRIBUTE_SWITCHER"; then
    is_switcher=1
  fi

  # Construct apps_for_dock

  # Mail.app
  if (( is_emailer )); then
    apps_for_dock+=( "$actual_path_to_app_Mail_app" )
  fi

  # Waterfox and Helium (which empirically rise and fall together, adjacent in the Dock)
  if (( ! is_bare_bones )); then
    apps_for_dock+=( 
      "$actual_path_to_app_Waterfox" 
      "$actual_path_to_app_Helium"
    )
  else
    apps_for_dock+=( "$actual_path_to_app_Safari" )
  fi

  # Raindrop.io
  if test_genomac_user_state "$USER_ATTRIBUTE_RAINDROP_IO"; then
    apps_for_dock+=( "$actual_path_to_app_Raindrop_io" )
  fi

  # Obsidian
  if test_genomac_user_state "$USER_ATTRIBUTE_OBSIDIAN_USER"; then
    apps_for_dock+=( "$actual_path_to_app_Obsidian" )
  fi

  # Microsoft Word
  if test_genomac_user_state "$USER_ATTRIBUTE_MICROSOFT_WORD"; then
    apps_for_dock+=( "$actual_path_to_app_Microsoft_Word" )
  fi

  # HIARCS Chess Explorer Pro
  if (( is_chessplayer )); then
    apps_for_dock+=( "$actual_path_to_app_HIARCS_Chess_Explorer_Pro" )
  fi

  # iTerm, Zed, and Tower
  if (( is_developer )); then
    apps_for_dock+=( 
      "$actual_path_to_app_iTerm" 
      "$actual_path_to_app_Zed"
      "$actual_path_to_app_Tower"
    )
  fi

  # System Settings is unconditional
  apps_for_dock+=( "$actual_path_to_app_System_Settings" )

  # Activity Monitor
  if (( is_developer || is_mac_admin )); then
    apps_for_dock+=( "$actual_path_to_app_Activity_Monitor" )
  fi
  
  # Disk Utility
  if (( is_mac_admin || is_switcher )); then
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
