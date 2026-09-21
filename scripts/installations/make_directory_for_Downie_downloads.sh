#!/usr/bin/env zsh

function conditionally_create_directory_for_Downie_downloads() {
  # Creates directory to serve as destination for downloads from Downie app.
  #
  # HINT: DIRECTORY_FOR_DOWNIE_DOWNLOADS="$HOME/Documents/Downie_downloads"

  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_DOWNIE_USER_WANTS_IT"; then
    report_to_log "Skipping creating directory for Downie.app downloads, because user doesn’t want this."
    report_end_phase_standard
    return 0
  fi

  report_action_taken_to_log "Create directory to serve as destination for downloads from Downie app: “${DIRECTORY_FOR_DOWNIE_DOWNLOADS}”"
  mkdir -p "$DIRECTORY_FOR_DOWNIE_DOWNLOADS"
  
  report_action_taken_to_log "Set permissions on Downie-downloads directory"
  chmod 700 "$DIRECTORY_FOR_DOWNIE_DOWNLOADS"
  
  report_end_phase_standard
}

