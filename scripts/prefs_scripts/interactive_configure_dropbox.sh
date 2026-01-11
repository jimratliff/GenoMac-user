#!/usr/bin/env zs

function conditionally_configure_dropbox() {
  report_start_phase_standard


  
  report_end_phase_standard
}

function configure_dropbox() {
  report_start_phase_standard

  report "Time to configure Dropbox! I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/Dropbox_how_to_configure.md" \
    "$BUNDLE_ID_DROPBOX" \
    "Follow the instructions in the Quick Look window to log into and configure Dropbox"
  
  report_end_phase_standard
}
