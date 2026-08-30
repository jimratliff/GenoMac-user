#!/usr/bin/env zsh

function conditionally_interactive_configure_spacejump() {
  report_start_phase_standard

  if test_genomac_user_state "$SESH_SPACEJUMP_USER_WANTS_IT"; then
    report "Skipping configuring SpaceJump because this user doesn’t want it."
    report_end_phase_standard
    return 0
  fi
  
  run_if_user_has_not_done "$PERM_ALFRED_HAS_BEEN_CONFIGURED" \
    interactive_configure_alfred \
    "Skipping configuring Alfred, because it’s already been configured"
  
  report_end_phase_standard
}
