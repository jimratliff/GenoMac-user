#!/usr/bin/env zsh

function conditionally_configure_helium() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_HELIUM_HAS_BEEN_CONFIGURED" \
    interactive_configure_helium \
    "Skipping configuring Helium because it’s been in the past"

  report_end_phase_standard
}

function interactive_configure_helium() {
  report_start_phase_standard
  
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Helium_how_to_configure.md" \
    "$BUNDLE_ID_HELIUM" \
    "Follow the instructions in the Quick Look window to configure Helium"
    
  report_end_phase_standard
}
