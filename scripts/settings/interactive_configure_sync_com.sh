#!/usr/bin/env zsh

function conditionally_configure_Sync_com() {
  report_start_phase_standard
  
  if test_genomac_user_state "$SESH_SYNC_COM_USER_WANTS_IT"; then
    run_if_user_has_not_done "$PERM_SYNC_COM_HAS_BEEN_CONFIGURED" \
      interactive_configure_Sync_com \
      "Skipping configuring Sync.com, because it’s already been configured."
  else
    "Skipping configuring Sync.com, because this user doesn’t want it."
  fi
  
  report_end_phase_standard
}

function interactive_configure_Sync_com() {
  report_start_phase_standard

  report "Time to configure Sync.com! I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Sync_com_how_to_configure.md" \
    "$BUNDLE_ID_SYNC_COM" \
    "Follow the instructions in the Quick Look window to log into and configure Sync.com"
  
  report_end_phase_standard
}
