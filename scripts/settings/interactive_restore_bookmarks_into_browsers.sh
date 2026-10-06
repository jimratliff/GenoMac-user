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
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard

  local destination_directory
  local destination_path
  local source_directory
  local source_path

  
  report_end_phase_standard
}

