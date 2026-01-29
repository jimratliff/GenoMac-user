#!/usr/bin/env zsh

function conditionally_configure_textexpander() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_TEXTEXPANDER_HAS_BEEN_CONFIGURED" \
    interactive_configure_textexpander \
    "Skipping authenticating TextExpander because it’s already been done"

  report_end_phase_standard
}

function interactive_configure_textexpander() {
  report_start_phase_standard
  
  launch_app_and_prompt_user_to_act \
    --show-doc "${GENOMAC_USER_DOCS_TO_DISPLAY_DIRECTORY}/TextExpander_how_to_configure.md" \
    "$BUNDLE_ID_TEXTEXPANDER" \
    "Follow the instructions in the Quick Look window to log into and configure TextExpander"
    
  report_end_phase_standard
}
