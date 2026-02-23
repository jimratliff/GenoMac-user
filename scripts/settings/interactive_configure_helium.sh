#!/usr/bin/env zsh

function conditionally_interactive_configure_helium() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_HELIUM_HAS_BEEN_CONFIGURED" \
    interactive_configure_helium \
    "Skipping configuring Helium because it’s been done in the past"

  run_if_user_has_not_done \
    "$PERM_HELIUM_EXTENSIONS_HAVE_BEEN_INSTALLED" \
    interactive_install_helium_extensions \
    "Skipping installing Helium extensions because this has been done in the past"

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

function interactive_install_helium_extensions() {
  report_start_phase_standard
  
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Helium_how_to_install_extensions.md" \
    "$BUNDLE_ID_HELIUM" \
    "Follow the instructions in the Quick Look window to install extensions for Helium"
    
  report_end_phase_standard
}
