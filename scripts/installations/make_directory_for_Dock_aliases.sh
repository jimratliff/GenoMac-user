#!/usr/bin/env zsh

function create_directory_for_aliases_for_Dock() {{
  # Creates directory of aliases, which directory will reside in the Dock.
  #
  # Doesn’t track (e.g., with a PERM or even a SESH state) whether this directory has been created before because
  # it’s just as easy to do a `mkdir -p`
  # But note then that this runs every time the Hypervisor is re-run, *even within the same session*.
  report_start_phase_standard
  report_action_taken "Create local aliases directory that resides in the Dock, if necessary: ${DIRECTORY_OF_ALIASES_FOR_DOCK}"
  mkdir -p "$DIRECTORY_OF_ALIASES_FOR_DOCK" ; success_or_not
  
  report_adjust_setting "Set permissions on local aliases-for-Dock directory"
  chmod 700 "$DIRECTORY_OF_ALIASES_FOR_DOCK" ; success_or_not
  report_end_phase_standard
}
