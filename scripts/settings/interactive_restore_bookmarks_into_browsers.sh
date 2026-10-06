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
  # Interactively walks user through restoring user-specific bookmarks into Waterfox, if those bookmarks exist.
  report_start_phase_standard

  # Check for nonempty directory of user-specific bookmark files to restore into browsers
  local -a entries
  entries=( "$USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY"/*(ND) )
  
  if [[ ! -d "$USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY" ]] || (( ${#entries} == 0 )); then
      report_to_log "Directory of user-specific bookmarks either doesn’t exist or is empty: $USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY"
      report_end_phase_standard
      return 0
  fi

  launch_app_and_prompt_user_to_act \
    --no-app \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_restore_bookmarks.md" \
    --open "$WATERFOX_USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY" \
    "Follow the instructions in the Quick Look window to restore your Waterfox bookmarks."

  report_end_phase_standard
}

function install_bookmarks_into_Helium() {
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard
  report_end_phase_standard
}

