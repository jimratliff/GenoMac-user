#!/usr/bin/env zsh

function conditionally_interactive_restore_bookmarks_into_browsers() {
  # Conditionally interactively restore user-specific bookmarks into browsers.

  report_start_phase_standard

  run_if_user_has_not_done "$PERM_WATERFOX_BOOKMARKS_HAVE_BEEN_RESTORED" \
    interactive_restore_bookmarks_into_Waterfox \
    "Skipping restoring bookmarks into Waterfox, because this has been done in the past"

  run_if_user_has_not_done "$PERM_HELIUM_BOOKMARKS_HAVE_BEEN_INSTALLED" \
    install_bookmarks_into_Helium \
    "Skipping restoring bookmarks into Helium, because this has been done in the past"

  run_if_user_has_not_done "$PERM_CHROME_BOOKMARKS_HAVE_BEEN_INSTALLED" \
    install_bookmarks_into_Chrome \
    "Skipping restoring bookmarks into Chrome, because this has been done in the past"
  
  report_end_phase_standard
}

function interactive_restore_bookmarks_into_Waterfox() {
  # Interactively walks user through restoring user-specific saved bookmarks (.json) into Waterfox, if those bookmarks exist.
  report_start_phase_standard

  local directory_of_bookmark_files
  directory_of_bookmark_files="$WATERFOX_USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY"

  if [[ ! -d "$directory_of_bookmark_files" ]]; then
    report_to_log "Skipping restoring bookmarks for Waterfox because no directory of user-specific Waterfox bookmarks exists at${NEWLINE}${directory_of_bookmark_files}"
    report_end_phase_standard
    return 0
  fi

  # Check for at least one .json file
  local -a bookmark_files
  local -a reply

  files_with_given_extensions "$directory_of_bookmark_files" ".json"
  bookmark_files=("${reply[@]}")

  if (( ${#bookmark_files} == 0 )); then
    report_to_log "Skipping restoring bookmarks for Waterfox because no .json files found at:${NEWLINE}${directory_of_bookmark_files}"
    report_end_phase_standard
    return 0
  fi

  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_restore_bookmarks.md" \
    --open "$directory_of_bookmark_files" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to restore your Waterfox bookmarks."

  report_end_phase_standard
}

function install_bookmarks_into_Helium() {
  # Installs a stored Bookmarks file, if one is found, into Helium’s default profile.
  #
  # Looks in HELIUM_USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY for files that don’t have
  # likely extensions, and chooses the alphabetically last of those. Then copies this file
  # as `Bookmarks` (no extension) into HELIUM_DEFAULT_PROFILE_DIRECTORY.
  #
  # Files with certain extensions (.md, .txt, .html, .json) are ignored to allow
  # HELIUM_USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY to contain annotation files (e.g., README.md)
  # or accessory bookmark files that would conveniently be stored nearby.
  
  report_start_phase_standard

  local backup_copy_path
  local destination_directory
  local destination_path
  local directory_of_bookmark_files
  local source_path
  
  directory_of_bookmark_files="$HELIUM_USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY"
  destination_directory="$HELIUM_DEFAULT_PROFILE_DIRECTORY"
  destination_path="${destination_directory}/Bookmarks"

  if [[ ! -d "$directory_of_bookmark_files" ]]; then
    report_to_log "Skipping installing bookmarks into Helium because no directory of user-specific Helium bookmarks exists at${NEWLINE}${directory_of_bookmark_files}"
    report_end_phase_standard
    return 0
  fi

  # Check for at least one candidate file by ignoring files with certain extensions
  local -a bookmark_files
  local -a extensions_to_ignore
  local -a reply

  extensions_to_ignore=(html json md txt zip)
  files_without_given_extensions "$directory_of_bookmark_files" "${extensions_to_ignore[@]}"
  bookmark_files=("${reply[@]}")

  if (( ${#bookmark_files} == 0 )); then
    report_to_log "Skipping installing bookmarks into Helium because no appropriate files found at:${NEWLINE}${directory_of_bookmark_files}"
    report_end_phase_standard
    return 0
  fi

  source_path="$(alphabetically_last_string "${bookmark_files[@]}")"

  # Test for existence of destination_directory; launch Helium if necessary to create
  if [[ ! -d "$destination_directory" ]]; then
    report_to_log "Helium default-profile doesn’t exist at ${destination_directory}."
    launch_and_quit_app "$BUNDLE_ID_HELIUM"
    if [[ ! -d "$destination_directory" ]]; then
      report_fail "Helium default-profile still doesn’t exist even after launching Helium:${NEWLINE}${destination_directory}"
      return 1
    fi
  fi

  backup_copy_path="${destination_path}.bak"

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_HELIUM"

  if [[ -d "$destination_path" || -d "$backup_copy_path" ]]; then
    report_fail "Expected file paths, but Bookmarks or Bookmarks.bak is a directory:${NEWLINE}${destination_path}${NEWLINE}${backup_copy_path}"
    return 1
  fi

  # Backup any existing Bookmarks file as Bookmarks.bak
  if [[ -e "$destination_path" ]]; then
    report_to_log "Backing up existing bookmarks to ${backup_copy_path}"
    cp -p -- "$destination_path" "$backup_copy_path"
  else
    report_to_log "No existing bookmarks to backup"
  fi

  # Copy chosen bookmarks file as Bookmarks
  report_to_log "Copying chosen bookmarks file.${NEWLINE}From:${source_path}${NEWLINE}To:${destination_path}"
  cp -p -- "$source_path" "$destination_path"
  
  report_end_phase_standard
}

function install_bookmarks_into_Chromium_browser() {
  # Installs a stored Bookmarks file, if one is found, into the specified Chromium browser’s default profile.
  #
  # Looks in the browser’s Bookmarks_to_restore directory for files that don’t have
  # likely extensions, and chooses the alphabetically last of those. Then copies this file
  # as `Bookmarks` (no extension) into the browser’s default-profile directory.
  #
  # Files with certain extensions (.md, .txt, .html, .json) are ignored to allow
  # the Bookmarks_to_restore directory to contain annotation files (e.g., README.md)
  # or accessory bookmark files that would conveniently be stored nearby.
  #
  # $1 Common name of browser (e.g., "Helium" or "Chrome")
  # $2 Path of browser-specific Bookmarks_to_restore directory (e.g., "$HELIUM_USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY")
  # $3 Path of this browser’s default-profile directory (e.g., "$HELIUM_DEFAULT_PROFILE_DIRECTORY")
  
  report_start_phase_standard

  local backup_copy_path
  local browser_name
  local destination_directory
  local destination_path
  local directory_of_bookmark_files
  local source_path

  browser_name="${1:?MISSING browser name}"
  directory_of_bookmark_files="${2:?MISSING path to Bookmarks_to_restore directory}"
  destination_directory="${3:?MISSING path to default-profile directory}"

  # Path of bookmarks file that will be written. Note that 'Bookmarks' is an extensionless file, not a directory.
  destination_path="${destination_directory}/Bookmarks"

  if [[ ! -d "$directory_of_bookmark_files" ]]; then
    report_to_log "Skipping installing bookmarks into Helium because no directory of user-specific Helium bookmarks exists at${NEWLINE}${directory_of_bookmark_files}"
    report_end_phase_standard
    return 0
  fi

  # Check for at least one candidate file by ignoring files with certain extensions
  local -a bookmark_files
  local -a extensions_to_ignore
  local -a reply

  extensions_to_ignore=(html json md txt zip)
  files_without_given_extensions "$directory_of_bookmark_files" "${extensions_to_ignore[@]}"
  bookmark_files=("${reply[@]}")

  if (( ${#bookmark_files} == 0 )); then
    report_to_log "Skipping installing bookmarks into Helium because no appropriate files found at:${NEWLINE}${directory_of_bookmark_files}"
    report_end_phase_standard
    return 0
  fi

  source_path="$(alphabetically_last_string "${bookmark_files[@]}")"

  # Test for existence of destination_directory; launch Helium if necessary to create
  if [[ ! -d "$destination_directory" ]]; then
    report_to_log "Helium default-profile doesn’t exist at ${destination_directory}."
    launch_and_quit_app "$BUNDLE_ID_HELIUM"
    if [[ ! -d "$destination_directory" ]]; then
      report_fail "Helium default-profile still doesn’t exist even after launching Helium:${NEWLINE}${destination_directory}"
      return 1
    fi
  fi

  backup_copy_path="${destination_path}.bak"

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_HELIUM"

  if [[ -d "$destination_path" || -d "$backup_copy_path" ]]; then
    report_fail "Expected file paths, but Bookmarks or Bookmarks.bak is a directory:${NEWLINE}${destination_path}${NEWLINE}${backup_copy_path}"
    return 1
  fi

  # Backup any existing Bookmarks file as Bookmarks.bak
  if [[ -e "$destination_path" ]]; then
    report_to_log "Backing up existing bookmarks to ${backup_copy_path}"
    cp -p -- "$destination_path" "$backup_copy_path"
  else
    report_to_log "No existing bookmarks to backup"
  fi

  # Copy chosen bookmarks file as Bookmarks
  report_to_log "Copying chosen bookmarks file.${NEWLINE}From:${source_path}${NEWLINE}To:${destination_path}"
  cp -p -- "$source_path" "$destination_path"
  
  report_end_phase_standard
}

