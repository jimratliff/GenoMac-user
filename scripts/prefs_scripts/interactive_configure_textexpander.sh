#!/usr/bin/env zs

function conditionally_configure_textexpander() {
  report_start_phase_standard

  _run_if_not_already_done \
    "$PERM_TEXTEXPANDER_HAS_BEEN_CONFIGURED" \
    configure_textexpander \
    "Skipping authenticating TextExpander because it’s already been done"

  report_end_phase_standard
}

function configure_textexpander() {
  report_start_phase_standard
  
  launch_app_and_prompt_user_to_act \
    --show-doc "${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/TextExpander_how_to_configure.md" \
    "$BUNDLE_ID_TEXTEXPANDER" \
    "Follow the instructions in the Quick Look window to log into and configure TextExpander"
    
  report_end_phase_standard
}
