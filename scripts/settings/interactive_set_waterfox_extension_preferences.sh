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
    "$PERM_WATERFOX_EXTENSION_MARKDOWNVIEWERWEBEXT_HAS_BEEN_CONFIGURED" \
    interactive_configure_waterfox_markdownviewerwebext_extension \
    "Skipping configuring the Markdown Viewer Webext extension for Waterfox, because it’s already been configured in the past"

  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSION_TABS2LIST_HAS_BEEN_CONFIGURED" \
    interactive_configure_waterfox_tabs2list_extension \
    "Skipping configuring the Tabs2List extension for Waterfox, because it’s already been configured in the past"

  if test_genomac_user_state "$PERM_WATERFOX_EXTENSION_YOUTUBE_WANTS_TO_CONFIGURE"; then
    run_if_user_has_not_done \
      "$PERM_WATERFOX_EXTENSION_YOUTUBE_HAS_BEEN_CONFIGURED" \
      interactive_configure_waterfox_youtube_extension \
      "Skipping configuring Enhanced for YouTube extension for Waterfox, because it’s already been specified in the past"
  fi

  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSION_THEME_HAS_BEEN_CONFIGURED" \
    interactive_configure_waterfox_theme \
    "Skipping installing the Activist-balanced Waterfox theme, because it’s already been installed in the past"

  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSION_RAINDROPIO_HAS_BEEN_CONFIGURED" \
    interactive_configure_waterfox_raindropio_extension \
    "Skipping configuring the Raindrop.io extension for Waterfox, because it’s already been configured in the past"

  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSION_SHORTCUTS_HAVE_BEEN_CONFIGURED" \
    interactive_configure_waterfox_extension_shortcuts \
    "Skipping configuring keyboard shortcuts for the extensions for Waterfox, because they’ve already been configured in the past"
	
  report_end_phase_standard
}

function interactive_configure_waterfox_basic_extensions() {
  report_start_phase_standard
  
  report "Time to configure basic browser extensions for Waterfox! I’ll launch Waterfox, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_basic_extensions.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure some basic extensions for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_consentomatic_extension() {
  report_start_phase_standard
  
  report "Time to configure the Consent-O-Matic extension for Waterfox! I’ll launch Waterfox, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_consentomatic_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure the Consent-O-Matic extension for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_managemytabs_extension() {
  report_start_phase_standard
  
  report "Time to configure the Manage My Tabs extension for Waterfox! I’ll launch Waterfox, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_managemytabs_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure the Manage My Tabs extension for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_markdownviewerwebext_extension() {
  report_start_phase_standard
  
  report "Time to configure the Markdown Viewer Webext extension for Waterfox! I’ll launch Waterfox, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_markdownviewerwebext_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure the Markdown Viewer Webext extension for Waterfox"

  report_end_phase_standard
}

function conditionally_interactive_configure_waterfox_raindropio_extension() {
  # This is intended to be executed later, within subdermis, after 1Password has been configured
  # because this configuration of Raindrop.io requires that the user signs into their Raindrop.io account
  run_if_user_has_not_done \
    "$PERM_WATERFOX_EXTENSION_RAINDROPIO_HAS_BEEN_CONFIGURED" \
    interactive_configure_waterfox_raindropio_extension \
    "Skipping configuring the Raindrop.io extension for Waterfox, because it’s already been configured in the past"
}

function interactive_configure_waterfox_raindropio_extension() {
  # NOTE: This requires logging into your Raindrop.io account. Thus, defer executing this function
  #       until after 1Password is configured.
  #
  # NOTE: The programmatic installation of Raindrop.io isn’t working, so this interactive configuration
  #       includes the installation step. TODO

  report_start_phase_standard
  
  report "Time to install and configure the Raindrop.io extension for Waterfox! I’ll launch Waterfox, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_raindropio_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to install and configure the Raindrop.io extension for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_theme() {
  # NOTE: The programmatic installation of this theme isn’t working, so this interactive configuration
  #       includes the installation step. TODO
  
  report_start_phase_standard
  
  report "Time to install the “Activist - Balanced” theme for Waterfox! I’ll launch Waterfox, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_theme_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to install and configure the “Activist - Balanced” theme for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_tabs2list_extension() {
  report_start_phase_standard
  
  report "Time to configure the Tabs2List extension for Waterfox! I’ll launch Waterfox, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_tabs2list_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure the Tabs2List extension for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_youtube_extension() {
  report_start_phase_standard
  
  report "Time to configure the Enhanced for YouTube browser extension for Waterfox! I’ll launch Waterfox, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_youtube_extension.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure Enhancer for YouTube for Waterfox"

  report_end_phase_standard
}

function interactive_configure_waterfox_extension_shortcuts() {
  report_start_phase_standard
  
  report "Time to configure keyboard shortcuts for extensions for Waterfox! I’ll launch Waterfox, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Waterfox_how_to_configure_extension_keyboard_shortcuts.md" \
    "$BUNDLE_ID_WATERFOX" \
    "Follow the instructions in the Quick Look window to configure keyboard shortcuts for extensions for Waterfox"

  report_end_phase_standard
}
