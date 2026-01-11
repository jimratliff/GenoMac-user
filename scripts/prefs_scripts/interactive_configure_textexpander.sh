#!/usr/bin/env zs

function conditionally_authenticate_TextExpander() {
  report_start_phase_standard

  _run_if_not_already_done \
    "$GMU_PERM_TEXTEXPANDER_HAS_BEEN_AUTHENTICATED" \
    authenticate_TextExpander \
    "Skipping authenticating TextExpander because it’s already been done"

  report_end_phase_standard
}

function authenticate_TextExpander() {
  report_start_phase_standard
  
  launch_app_and_prompt_user_to_act \
    # --show-doc "${GENOMAC_USER_LOCAL_DOCUMENTATION_DIRECTORY}/TextExpander_how_to_log_in.md" \
    "$BUNDLE_ID_TEXTEXPANDER" \
    # "Follow the instructions in the Quick Look window to log into your 1Password account in the 1Password app"
    "I will launch TextExpander. Log into the TextExpander service and acknowledge when you’ve done so"
    
  report_end_phase_standard
}
