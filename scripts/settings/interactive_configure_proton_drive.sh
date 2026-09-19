#!/usr/bin/env zsh

function conditionally_configure_Proton_Drive() {
  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_PROTON_DRIVE_USER_WANTS_IT"; then
    report_to_log "Skipping configuring Proton Drive, because this user doesn’t want it"
    report_end_phase_standard
    return 0
  fi
  
  if test_genomac_user_state "$PERM_PROTON_DRIVE_HAS_BEEN_CONFIGURED"; then
    report to log "Skipping configuring Proton Drive, because it’s already been configured."
    report_end_phase_standard
    return 0
  fi

  interactive_configure_Proton_Drive
  
  report_end_phase_standard
}

function interactive_configure_Proton_Drive() {
  # Interactively configure Proton Drive.
  #
  # - Looks for an optional user-specific Markdown file in $USER_SPECIFIC_META_DIRECTORY
  #   to be displayed via QuickLook to guide the user through interactively configuring
  #   internet accounts.
  # - If this file is not present, an alternative, default document is displayed instead.
  
  report_start_phase_standard

  local default_markdown_page_file
  local markdown_file_to_display
  local user_specific_markdown_page_file

  default_markdown_page_file="${GMU_DOCS_TO_DISPLAY}/${PROTON_DRIVE_SPECIFICATION_MARKDOWN_PAGE_FILENAME}"
  user_specific_markdown_page_file="${USER_SPECIFIC_PROTON_DRIVE_SPECIFICATIONS_FILE}"

  if file_exists_and_if_so_is_readable "$user_specific_markdown_page_file"; then
    markdown_file_to_display="$user_specific_markdown_page_file"
  else
    markdown_file_to_display="$default_markdown_page_file"
  fi

  report "Time to configure Proton Drive! I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "$markdown_file_to_display" \
    "$BUNDLE_ID_PROTON_DRIVE" \
    "Follow the instructions in the Quick Look window to log into and configure Proton Drive"
  
  report_end_phase_standard
}
