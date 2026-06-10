#!/usr/bin/env zsh

conditionally_configure_hiarcs_ce_pro() {
  report_start_phase_standard

  if ! test_genomac_user_state "$PERM_HIARCS_CHESS_EXPLORER_PRO_USER_WANTS_IT"; then
    report_action_taken_to_log "Skipping HIARCS Chess Explorer Pro configuration, because this user doesn’t want it"
    report_end_phase_standard
    return 0
  fi
  
  run_if_user_has_not_done \
    "$PERM_HIARCS_CHESS_EXPLORER_PRO_HAS_BEEN_BOOTSTRAPPED" \
    bootstrap_hiarcs_ce_pro \
    "Skipping bootstrapping HIARCS Chess Explorer Pro because it’s been done in the past"

  configure_hiarcs_ce_pro_idempotent_settings
    
  report_end_phase_standard
}

function bootstrap_hiarcs_ce_pro() {
  # Bootstrap HIARCS Chess Explorer Pro
  report_start_phase_standard

  report_warning "NOT YET IMPLEMENTED: bootstrap_hiarcs_ce_pro()"
  
  report_end_phase_standard
}

function configure_hiarcs_ce_pro_idempotent_settings() {
  # Configure HIARCS Chess Explorer Pro’s idempotent settings
  report_start_phase_standard

  report_warning "NOT YET IMPLEMENTED: configure_hiarcs_ce_pro_idempotent_settings()"
  
  report_end_phase_standard
}
