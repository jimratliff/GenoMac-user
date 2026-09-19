#!/usr/bin/env zsh

function create_directory_for_ScanSnap_inbox() {
  # Creates directory for ScanSnap inbox
  # HINT: SCANSNAP_INBOX_DIRECTORY="${LOCAL_DROPBOX_DIRECTORY}/ScanSnap_inbox"
  report_start_phase_standard
  report_action_taken "Create directory, if necessary, for ScanSnap inbox: ${SCANSNAP_INBOX_DIRECTORY}"
  mkdir -p "$SCANSNAP_INBOX_DIRECTORY" ; success_or_not
  
  report_adjust_setting "Set permissions on ScanSnap inbox directory"
  chmod 700 "$SCANSNAP_INBOX_DIRECTORY" ; success_or_not
  report_end_phase_standard
}
