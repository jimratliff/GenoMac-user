#!/usr/bin/env zsh

function conditionally_interactive_configure_Proton_Mail_Bridge() {
  # Conditionally interactively configures Proton Mail Bridge.

  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_PROTON_MAIL_BRIDGE_USER_WANTS_IT"; then
    report_to_log "Skipping configuring Proton Mail Bridge, because user doesn’t use it."
    report_end_phase_standard
    return 0
  fi

  run_if_user_has_not_done "$PERM_PROTON_MAIL_BRIDGE_HAS_BEEN_CONFIGURED" \
    interactive_configure_Proton_Mail_Bridge \
    "Skipping configuring Proton Mail Bridge, because it’s been configured in the past"
  
  report_end_phase_standard
  
}

function interactive_configure_Proton_Mail_Bridge() {
  # Interactively configures Proton Mail Bridge settings.
  report_start_phase_standard
  
  report "Time to configure Proton Mail Bridge! I’ll launch it, and open a window with instructions for next steps"

  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Proton_Mail_Bridge_how_to_configure.md" \
    "$BUNDLE_ID_PROTON_MAIL_BRIDGE" \
    "Follow the instructions in the Quick Look window to configure Proton Mail Bridge"
  
  report_end_phase_standard
}
