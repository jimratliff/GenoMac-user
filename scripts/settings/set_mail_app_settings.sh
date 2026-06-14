#!/usr/bin/env zsh

conditionally_configure_mail_app() {
  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_APPLE_MAIL_APP_USER_WANTS_IT"; then
    report_action_taken_to_log "Skipping Mail.app configuration, because this user doesn’t want it"
    report_end_phase_standard
    return 0
  fi
  
  run_if_user_has_not_done \
    "$PERM_APPLE_MAIL_APP_HAS_BEEN_BOOTSTRAPPED" \
    bootstrap_mail_app \
    "Skipping bootstrapping Mail.app because it’s been done in the past"

  configure_mail_app_idempotent_settings
    
  report_end_phase_standard
}

function bootstrap_mail_app() {
  # Bootstrap Mail.app
  report_start_phase_standard

  report_warning "NOT YET IMPLEMENTED: bootstrap_mail_app()"
  
  report_end_phase_standard
}

function configure_mail_app_idempotent_settings() {
  # Configure Mail.app idempotent settings
  report_start_phase_standard

  report_warning "NOT YET IMPLEMENTED: configure_mail_app_idempotent_settings()"
  
  report_end_phase_standard
}
