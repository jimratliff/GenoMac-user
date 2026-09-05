#!/usr/bin/env zsh

function conditionally_set_user_finder_sidebar_favorites() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_FINDER_SIDEBAR_HAS_BEEN_ARRANGED" \
    set_user_finder_sidebar_favorites_if_specified \
    "Skipping setting Finder sidebar Favorites items, because this was done in the past."
  
  report_end_phase_standard
}

function set_user_finder_sidebar_favorites_if_specified() {
  # Looks for user-specific JSON list of (name, path) pairs of items to add to Finder’s sidebar Favorites.
  #
  # HINT: USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILENAME="finder_sidebar_favorites_name_path_pairs.json"
  # HINT: USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILE="${USER_SPECIFIC_META_DIRECTORY}/${USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILENAME}"
  
  report_start_phase_standard

  local file_to_read="$USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILE"

  if ! file_exists_and_is_readable "$file_to_read"; then
    report_to_log "Skipping setting Finder sidebar Favorites, because no specification file was found at “${file_to_read}”.}
    report_end_phase_standard
    return 0
  fi

  set_user_finder_sidebar_favorites
  
  report_about_to_kill_app "Finder"
  killall "Finder" ; success_or_not
  
  report_end_phase_standard
}

function set_user_finder_sidebar_favorites() {
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard

  local file_to_read="$USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILE"
  
  report_about_to_kill_app "Finder"
  killall "Finder" ; success_or_not
  
  report_end_phase_standard
}
