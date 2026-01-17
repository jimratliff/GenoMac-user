#!/usr/bin/env zs

function conditionally_configure_Dropbox() {
  report_start_phase_standard
  
  if test_genomac_user_state "$PERM_DROPBOX_USER_WANTS_IT"; then
    run_if_user_has_not_done "$PERM_DROPBOX_HAS_BEEN_CONFIGURED" \
      interactive_configure_Dropbox \
      "Skipping basic bootstrap operations, because they’ve already been performed"
  fi
  
  report_end_phase_standard
}

function interactive_configure_Dropbox() {
  report_start_phase_standard

  report "Time to configure Dropbox! I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/Dropbox_how_to_configure.md" \
    "$BUNDLE_ID_DROPBOX" \
    "Follow the instructions in the Quick Look window to log into and configure Dropbox"
  
  report_end_phase_standard
}
