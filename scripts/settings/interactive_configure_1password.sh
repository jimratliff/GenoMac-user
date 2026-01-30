#!/usr/bin/env zsh

# Conditionally prompts/guides user to (a) sign into their 1Password account and (b) configure its SSH agent
#
# Much of the 1Password configuration must be done by the user manually, because it doesn’t admit
# to standard `defaults write` techniques.
#
# Relies on the following Markdown files residing in resources/docs_to_display_to_user:
# - 1Password_how_to_log_in.md
# - 1Password_how_to_configure.md

function conditionally_configure_1Password() {
  # At this point, (a) GenoMac-system has installed both 1Password.app and the 1Password-CLI app and 
  # (b) GenoMac-user has deployed dotfiles necessary for the integration of 1Password with GitHub authentication
  #
  # It is assumed that all users want to be authenticated with 1Password.
  # However, each user can choose whether to go to the extra effort to configure 1Password’s SSH agent
  #
  # It is assumed that: if a user has configured 1Password, then that user has also authenticated 1Password
  
  report_start_phase_standard

  # Skip if 1Password has been previously configured for this user (even in an earlier session)
  if test_genomac_user_state "$PERM_1PASSWORD_HAS_BEEN_CONFIGURED"; then
    report_action_taken "Skipping 1Password configuration, because it’s already been configured and it’s a bootstrapping step"
    report_end_phase_standard
    return 0
  fi

  # Conditionally prompt user to authenticate their 1Password account in the 1Password app on the Mac
  run_if_user_has_not_done "$PERM_1PASSWORD_HAS_BEEN_AUTHENTICATED" \
    authenticate_1Password \
    "Skipping authenticating 1Password, because it’s already been authenticated and it’s a bootstrapping step."

  # Conditionally prompt user to configure their already-authenticated 1Password
  run_if_user_state "$PERM_1PASSWORD_USER_WANTS_TO_CONFIGURE_SSH_AGENT" \
    configure_and_verify_authenticated_1Password \
    "Skipping 1Password configuration, because this user doesn’t want it."

  report_end_phase_standard
}

function authenticate_1Password() {
  report_start_phase_standard
  
  report "Time to authenticate 1Password! I’ll launch it, and open a window with instructions for logging into 1Password"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/1Password_how_to_log_in.md" \
    "$BUNDLE_ID_1PASSWORD" \
    "Follow the instructions in the Quick Look window to log into your 1Password account in the 1Password app"

  report_end_phase_standard
}

function configure_authenticated_1Password() {
  # Prompt user to configure settings of 1Password
  report_start_phase_standard
  
  report_action_taken "Time to configure 1Password! I'll launch it, and open a window with instructions to follow"
  
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/1Password_how_to_configure.md" \
    "$BUNDLE_ID_1PASSWORD" \
    "Follow the instructions in the Quick Look window to configure 1Password"

	report_end_phase_standard
}

function configure_and_verify_authenticated_1Password() {
  # Prompt user to configure settings of 1Password
  report_start_phase_standard
  configure_authenticated_1Password
  if ! verify_ssh_agent_configuration; then
    report_fail "The attempt to configure 1Password to SSH authenticate with GitHub has failed ☹️"
    report_end_phase_standard
    return 1
  fi
  
  report success "✅ 1Password successfully configured to SSH authenticate with GitHub"
  set_genomac_user_state "$PERM_1PASSWORD_HAS_BEEN_CONFIGURED"
  report_end_phase_standard
}

function verify_ssh_agent_configuration() {
  report_start_phase_standard
  if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
    report_error "SSH_AUTH_SOCK is not set. Failed: SSH agent not configured"
    report_end_phase_standard
    return 1
  fi
  
  # Try to authenticate to GitHub via SSH
  report_action_taken "Testing SSH auth with: ssh -T git@github.com"
  
  ssh_output=$(ssh -T git@github.com 2>&1) || true  # Don't let failure abort script
  
  if [[ "$ssh_output" == *"successfully authenticated"* ]]; then
    print -r -- "${SYMBOL_SUCCESS}SSH authentication with GitHub succeeded"
    report_success "Verified: SSH agent is working"
    report_end_phase_standard
    return 0
  else
    local lines=(
          "SSH authentication failed. Output:"
          "${ssh_output}"
          "${SYMBOL_FAILURE}SSH authentication with GitHub failed"
        )
    local warning_msg="${(F)lines}"  # (F) joins with newlines
	report_warning "$warning_msg"
    report_end_phase_standard
    return 1
  fi

}
