#!/usr/bin/env zsh

# Relies on the following Markdown files residing in resources/docs_to_display_to_user:
# - Waterfox_how_to_configure_basic_extensions.md
# - Waterfox_how_to_configure_youtube_extension.md

function interactive_set_preferences_for_waterfox_extensions() {

  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSIONS_BASIC_HAVE_BEEN_CONFIGURED" \
    interactive_configure_waterfox_basic_extensions \
    "Skipping configuring the most-basic Waterfox extensions, because they’ve already been configured in the past"

  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSION_CONSENTOMATIC_HAS_BEEN_CONFIGURED" \
    interactive_configure_waterfox_consentomatic_extension \
    "Skipping configuring the Consent-O-Matic extension for Waterfox, because it’s already been configured in the past"

  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSION_MANAGEMYTABS_HAS_BEEN_CONFIGURED" \
    interactive_configure_waterfox_managemytabs_extension \
    "Skipping configuring the Manage My Tabs extension for Waterfox, because it’s already been configured in the past"

  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSION_TABS2LIST_HAS_BEEN_CONFIGURED" \
    interactive_configure_waterfox_tabs2list_extension \
    "Skipping configuring the Tabs2List extension for Waterfox, because it’s already been configured in the past"

  if test_user_state "$PERM_WATERFOX_EXTENSION_YOUTUBE_WANTS_TO_CONFIGURE"; then
    run_if_user_has_not_done \
      "$PERM_WATERFOX_EXTENSION_YOUTUBE_HAS_BEEN_CONFIGURED" \
      interactive_configure_waterfox_youtube_extension \
      "Skipping configuring Enhanced for YouTube extension for Waterfox, because it’s already been specified in the past"

  ############### WIP: REVIEW THE KEYBOARD SHORTCUTS FOR ALL EXTENSIONS
	
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

function interactive_configure_waterfox_consentomatic_extension() {
  report_start_phase_standard
  
  report "Time to configure the Consent-O-Matic extension for Waterfox! I’ll launch it, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_consentomatic_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure the Consent-O-Matic extension for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_managemytabs_extension() {
  report_start_phase_standard
  
  report "Time to configure the Manage My Tabs extension for Waterfox! I’ll launch it, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_managemytabs_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure the Manage My Tabs extension for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_tabs2list_extension() {
  report_start_phase_standard
  
  report "Time to configure the Tabs2List extension for Waterfox! I’ll launch it, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_tabs2list_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure the Tabs2List extension for Waterfox"

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
