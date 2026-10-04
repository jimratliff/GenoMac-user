#!/usr/bin/env zsh

function conditionally_interactive_restore_bookmarks_into_browsers() {
  # Conditionally interactively restore user-specific bookmarks into browsers.

  report_start_phase_standard

  run_if_user_has_not_done "$PERM_BOOKMARKS_HAVE_BEEN_IMPORTED_BY_USER_INTO_BROWSERS" \
    interactive_restore_bookmarks_into_browsers \
    "Skipping interactively restoring bookmarks, because this has been done in the past"
  
  report_end_phase_standard
  
}

function interactive_restore_bookmarks_into_browsers() {
  # Interactively walks user through restoring user-specific bookmarks, if those bookmarks exist.
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
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Bookmarks_how_to_restore_into_browsers.md" \
    --open "$USER_SPECIFIC_BOOKMARKS_TO_RESTORE_DIRECTORY" \
    "Follow the instructions in the Quick Look window to restore your bookmarks into browsers."

  report_end_phase_standard
}

