#!/usr/bin/env zsh

function conditionally_interactive_configure_Notion() {
  report_start_phase_standard
  
  if test_genomac_user_state "$SESH_NOTION_USER_WANTS_IT"; then
    run_if_user_has_not_done "$PERM_NOTION_HAS_BEEN_CONFIGURED" \
      interactive_configure_Notion \
      "Skipping configuring Notion, because it’s already been configured."
  fi
  
  report_end_phase_standard
}

function interactive_configure_Notion() {
  report_start_phase_standard

  report "Time to configure Notion! I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Notion_how_to_configure.md" \
    "$BUNDLE_ID_NOTION" \
    "Follow the instructions in the Quick Look window to log into and configure Notion"
  
  report_end_phase_standard
}

