#!/usr/bin/env zsh

function conditionally_configure_Obsidian() {
  report_start_phase_standard

  report_warning "The configuration of Obsidian hasn’t been implemented yet!"
  return 0
  
  if test_genomac_user_state "$SESH_OBSIDIAN_USER_WANTS_IT"; then
    run_if_user_has_not_done "$PERM_OBSIDIAN_HAS_BEEN_CONFIGURED" \
      interactive_configure_Obsidian \
      "Skipping configuring Obsidian, because it’s already been configured."
  fi
  
  report_end_phase_standard
}

function interactive_configure_Obsidian() {
  report_start_phase_standard

  report_warning "The configuration of Obsidian hasn’t been implemented yet!"
  return 0

  create_directory_for_obsidian_vaults   # scripts/installations/make_obsidian_vaults_directory.sh

  report "Time to configure Obsidan! I’ll launch it, and open a window with instructions for next steps"

  ############### TODO: I’ll probably also want to open $USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY
  #                     by adding --open "$USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Obsidian_how_to_configure.md" \
    "$BUNDLE_ID_OBSIDIAN" \
    "Follow the instructions in the Quick Look window to log into and configure Obsidian"
  
  report_end_phase_standard
}
