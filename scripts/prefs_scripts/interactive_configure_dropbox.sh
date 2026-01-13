#!/usr/bin/env zs

function conditionally_configure_Dropbox() {
  report_start_phase_standard
  
  if test_genomac_user_state "$GMU_PERM_USER_WILL_USE_DROPBOX"; then
    _run_if_not_already_done "$GMU_PERM_DROPBOX_HAS_BEEN_CONFIGURED" \
      configure_Dropbox \
      "Skipping basic bootstrap operations, because they’ve already been performed"
  fi
  
  report_end_phase_standard
}

function configure_Dropbox() {
  report_start_phase_standard

  report "Time to configure Dropbox! I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/Dropbox_how_to_configure.md" \
    "$BUNDLE_ID_DROPBOX" \
    "Follow the instructions in the Quick Look window to log into and configure Dropbox"
  
  report_end_phase_standard
}
