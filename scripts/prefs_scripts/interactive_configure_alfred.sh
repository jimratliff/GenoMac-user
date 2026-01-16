#!/usr/bin/env zs

function conditionally_configure_alfred() {
  report_start_phase_standard
  
  _run_if_not_already_done "$PERM_ALFRED_HAS_BEEN_CONFIGURED" \
    configure_alfred \
    "Skipping configuring Alfred, because it’s already been configured"
  
  report_end_phase_standard
}

function configure_alfred() {
  report_start_phase_standard

  report "Time to configure Alfred! I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/Alfred_how_to_configure.md" \
    "$BUNDLE_ID_DROPBOX" \
    "Follow the instructions in the Quick Look window to log into and configure Alfred"
  
  report_end_phase_standard
}
