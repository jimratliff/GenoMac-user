#!/usr/bin/env zsh

function conditionally_create_directory_for_aliases_for_Dock() {
  # Conditionally create directory of aliases, which directory will reside in the Dock.
  report_start_phase_standard

  run_if_user_has_not_done \
    "$SESH_ALIAS_DIRECTORY_HAS_BEEN_CREATED" \
    create_directory_for_aliases_for_Dock \
    "Skipping creating directory for Finder alias files, because this was done earlier this session."
    
  report_end_phase_standard
}

function create_directory_for_aliases_for_Dock() {
  # Creates directory of aliases, which directory will reside in the Dock.
  # Adds a README explaining purpose of this directory.
  #
  # Executes every session, i.e., even if this directory has been created during a previous session.
  # This wasy it heals either a deletion of the directory or a screw up in the permissions.

  report_start_phase_standard

  local readme_file_path="${GMU_FILES_TO_COPY_ELSEWHERE}/0_README_aliases_for_Dock.md"

  report_action_taken "Create directory for Finder alias files to be referenced from the Dock: “${DIRECTORY_OF_ALIASES_FOR_DOCK}”"
  mkdir -p "$DIRECTORY_OF_ALIASES_FOR_DOCK" ; success_or_not
  
  report_adjust_setting "Set permissions on local aliases-for-Dock directory"
  chmod 700 "$DIRECTORY_OF_ALIASES_FOR_DOCK" ; success_or_not

  report_action_taken "Copy README to aliases-for-Dock directory, replacing any existing version"
  cp -f "$readme_file_path" "$DIRECTORY_OF_ALIASES_FOR_DOCK/" ; success_or_not
  
  report_end_phase_standard
}
