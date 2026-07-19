#!/usr/bin/env zsh

function conditionally_configure_Proton_Drive() {
  report_start_phase_standard
  
  if test_genomac_user_state "$SESH_PROTON_DRIVE_USER_WANTS_IT"; then
    run_if_user_has_not_done "$PERM_PROTON_DRIVE_HAS_BEEN_CONFIGURED" \
      interactive_configure_Proton_Drive \
      "Skipping configuring Proton Drive, because it’s already been configured."
  fi
  
  report_end_phase_standard
}

function interactive_configure_Proton_Drive() {
  report_start_phase_standard

  report "Time to configure Proton Drive! I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Proton_Drive_how_to_configure.md" \
    "$BUNDLE_ID_PROTON_DRIVE" \
    "Follow the instructions in the Quick Look window to log into and configure Proton Drive"
  
  report_end_phase_standard
}
