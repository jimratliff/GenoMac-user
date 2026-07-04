#!/usr/bin/env zsh

function conditionally_configure_Obsidian() {
  report_start_phase_standard

  ############### BEGIN: TO BE REMOVED ###############
  # report_warning "The configuration of Obsidian hasn’t been implemented yet!"
  # report_end_phase_standard
  # return 0
  ############### END: TO BE REMOVED ###############
  
  if test_genomac_user_state "$SESH_OBSIDIAN_USER_WANTS_IT"; then
    run_if_user_has_not_done "$PERM_OBSIDIAN_HAS_BEEN_CONFIGURED" \
      interactive_configure_Obsidian \
      "Skipping configuring Obsidian, because it’s already been configured."
  fi
  
  report_end_phase_standard
}

function interactive_configure_Obsidian() {
  report_start_phase_standard
  
  # TODO: I need to go through the configuration process:
  #       - see what needs to be done,
  #       - fill in Obsidian_how_to_configure.md

  ############### BEGIN: TO BE REMOVED ###############
  # report_warning "The configuration of Obsidian hasn’t been implemented yet!"
  # report_end_phase_standard
  # return 0
  ############### END: TO BE REMOVED ###############

  create_directory_for_obsidian_vaults 

  report "Time to configure Obsidan! I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Obsidian_how_to_configure.md" \
	--open "$USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY" \ 
    "$BUNDLE_ID_OBSIDIAN" \
    "Follow the instructions in the Quick Look window to log into and configure Obsidian"
  
  report_end_phase_standard
}

function create_directory_for_obsidian_vaults() {
  # Creates directory for Obsidian vaults
  #
  # Hint: USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY="$HOME/Documents/Obsidian_vaults"
  report_start_phase_standard
  
  report_action_taken_to_log "Create local directory for Obsidian vaults, if necessary: ${USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY}"
  mkdir -p "$USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY" ; success_or_not
  
  report_action_taken_to_log "Set permissions on local Obsidian-vaults directory"
  chmod 755 "$USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY" ; success_or_not
  
  report_end_phase_standard
}
