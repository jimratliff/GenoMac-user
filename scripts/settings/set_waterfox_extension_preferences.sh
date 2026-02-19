#!/usr/bin/env zsh

function conditionally_implement_preferences_for_waterfox_extensions() {

  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSIONS_BASIC_HAVE_BEEN_CONFIGURED" \
    interactive_configure_waterfox_basic_extensions \
    "Skipping configuring the most-basic Waterfox extensions, because they’ve already been configured in the past"

  if test_user_state "$PERM_WATERFOX_EXTENSION_YOUTUBE_WANTS_TO_CONFIGURE"; then
    run_if_user_has_not_done \
      "$PERM_WATERFOX_EXTENSION_YOUTUBE_HAS_BEEN_CONFIGURED" \
      interactive_configure_waterfox_youtube_extension \
      "Skipping configuring Enhanced for YouTube extension for Waterfox, because it’s already been specified in the past"
	
  report_end_phase_standard
}

function interactive_configure_waterfox_basic_extensions() {
  report_start_phase_standard
  
  report "Time to configure basic browser extensions for Waterfox! I’ll launch it, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_basic_extensions.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure some basic extensions for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_youtube_extension() {
  report_start_phase_standard
  
  report "Time to configure the Enhanced for YouTube browser extension for Waterfox! I’ll launch it, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_youtube_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure Enhancer for YouTube for Waterfox"

  report_end_phase_standard
}
