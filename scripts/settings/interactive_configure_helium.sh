#!/usr/bin/env zsh

function conditionally_interactive_configure_helium_and_extensions() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_HELIUM_HAS_BEEN_CONFIGURED" \
    interactive_configure_helium \
    "Skipping configuring Helium because it’s been done in the past"

  run_if_user_has_not_done \
    "$PERM_HELIUM_EXTENSIONS_HAVE_BEEN_INSTALLED" \
    interactive_install_helium_extensions \
    "Skipping installing Helium extensions because this has been done in the past"

  run_if_user_has_not_done \
    "$PERM_HELIUM_EXTENSIONS_BASIC_HAVE_BEEN_CONFIGURED" \
    interactive_configure_helium_basic_extensions \
    "Skipping configuring the most-basic Helium extensions, because they’ve already been configured in the past"

  if test_genomac_user_state "$SESH_HELIUM_EXTENSION_YOUTUBE_ENHANCER_USER_WANTS_IT"; then
    run_if_user_has_not_done \
      "$PERM_HELIUM_EXTENSION_YOUTUBE_HAS_BEEN_CONFIGURED" \
      interactive_configure_helium_youtube_extension \
      "Skipping configuring Enhanced for YouTube extension for Helium,${NEWLINE}because it’s already been specified in the past"
  else
    report_action_taken "Skipping configuring Enhanced for YouTube extension for Helium,${NEWLINE}because this user doesn’t want it."
  fi

  report_end_phase_standard
}

function interactive_configure_helium() {
  report_start_phase_standard

  report "Time to configure settings for Helium! I’ll launch Helium, and open a window with instructions"
  
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Helium_how_to_configure.md" \
    "$BUNDLE_ID_HELIUM" \
    "Follow the instructions in the Quick Look window to configure Helium"
    
  report_end_phase_standard
}

function interactive_install_helium_extensions() {
  report_start_phase_standard

  report "Time to install extensions for Helium! I’ll launch Helium, and open a window with instructions"
  
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Helium_how_to_install_extensions.md" \
    "$BUNDLE_ID_HELIUM" \
    "Follow the instructions in the Quick Look window to install extensions for Helium"
    
  report_end_phase_standard
}

function interactive_configure_helium_basic_extensions() {
  report_start_phase_standard
  
  report "Time to configure basic browser extensions for Helium! I’ll launch Helium, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Helium_how_to_configure_basic_extensions.md" \
    "$BUNDLE_ID_HELIUM" \
    "Follow the instructions in the Quick Look window to configure some basic extensions for Helium"

  report_end_phase_standard
}

function interactive_configure_helium_youtube_extension() {
  report_start_phase_standard
  
  report "Time to configure the Enhanced for YouTube browser extension for Helium! I’ll launch Helium, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Helium_how_to_configure_youtube_extension.md" \
    "$BUNDLE_ID_HELIUM" \
    "Follow the instructions in the Quick Look window to configure Enhancer for YouTube for Helium"

  report_end_phase_standard
}
