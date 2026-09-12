#!/usr/bin/env zsh

function create_directory_for_aliases_for_Dock() {
  # Creates directory of aliases, which directory will reside in the Dock.
  # Adds a README explaining purpose of this directory.
  #
  # HINT: DIRECTORY_OF_ALIASES_FOR_DOCK="$HOME/Documents/Aliases_for_Dock"

  report_start_phase_standard

  # HINT: GMU_FILES_TO_COPY_ELSEWHERE="${GMU_RESOURCES}/files_to_be_copied_elsewhere"
  local readme_file_path="${GMU_FILES_TO_COPY_ELSEWHERE}/0_README_aliases_for_Dock.md"

  report_action_taken_to_log "Create directory for Finder alias files to be referenced from the Dock: “${DIRECTORY_OF_ALIASES_FOR_DOCK}”"
  mkdir -p "$DIRECTORY_OF_ALIASES_FOR_DOCK"
  
  report_action_taken_to_log "Set permissions on local aliases-for-Dock directory"
  chmod 700 "$DIRECTORY_OF_ALIASES_FOR_DOCK"
  
  report_action_taken_to_log "Copy README to aliases-for-Dock directory, replacing any existing version"
  cp -f "$readme_file_path" "$DIRECTORY_OF_ALIASES_FOR_DOCK/"
  
  report_end_phase_standard
}
