#!/usr/bin/env zsh

# Conditionally prompts/guides user to (a) sign into their 1Password account, (b) implement basic
# preferences, and (c) if desired, configure its SSH agent
#
# Essentially all of the 1Password configuration must be done by the user manually, because 1Password
# erects a not practically surmountable obstacle to programmatic modification of its preferences
# (hashes the key-value pairs in a nonreplicable-by-me way).
#
# Relies on the following Markdown files residing in resources/docs_to_display_to_user:
# - 1Password_how_to_add_nonstandard_browsers.md
# - 1password_how_to_basically_configure.sh
# - 1Password_how_to_configure_for_ssh.md
# - 1Password_how_to_log_in.md

function conditionally_configure_1Password() {
  # At this point, (a) GenoMac-system has installed both 1Password.app and the 1Password-CLI app and 
  # (b) GenoMac-user has deployed dotfiles necessary for the integration of 1Password with GitHub
  # authentication
  #
  # It is assumed that all users want to use 1Password to authenticate at least on websites. Thus, all
  # users want to sign into their 1Password account and basically configure the 1Password app.
  #
  # However, each user can choose whether to go to the extra effort to configure 1Password’s SSH agent.
  # This user decision is determined via
  # scripts/settings/interactive_ask_initial_questions.sh » interactive_ask_initial_questions
  # via the state PERM_1PASSWORD_USER_WANTS_TO_CONFIGURE_SSH_AGENT
  
  report_start_phase_standard

  # Conditionally prompt user to authenticate their 1Password account in the 1Password app on the Mac
  run_if_user_has_not_done "$PERM_1PASSWORD_HAS_BEEN_AUTHENTICATED" \
    interactive_authenticate_1Password \
    "Skipping signing into 1Password, because you’ve signed into it in the past"

  # Conditionally prompt user to configure basic settings for 1Password
  run_if_user_has_not_done \
    "$PERM_1PASSWORD_HAS_BEEN_BASICALLY_CONFIGURED" \
    interactive_basic_configure_1password \
    "Skipping basic configuration of 1Password, because you've done that in the past."

  # Conditionally prompt user to add nonstandard browsers for 1Password
  run_if_user_has_not_done \
    "$PERM_1PASSWORD_NONSTANDARD_BROWSERS_HAVE_BEEN_CONFIGURED" \
    interactive_permit_1password_use_nonstandard_browsers \
    "Skipping adding nonstandard browsers for 1Password, because you've done that in the past."

  if ! test_user_state "$PERM_1PASSWORD_USER_WANTS_TO_CONFIGURE_SSH_AGENT"; then
    report_action_taken "Skipping configuring 1Password for SSH with GitHub, because it’s not desired"
	report_end_phase_standard
	return 0
  fi

  # Conditionally prompt user to configure SSH settings for use with GitHub
  run_if_user_has_not_done \
    "$PERM_1PASSWORD_HAS_BEEN_CONFIGURED_FOR_SSH" \
    configure_and_verify_1Password_for_SSH_with_GitHub \
    "Skipping SSH configuration of 1Password, because you've done that in the past."

  report_end_phase_standard
}

function interactive_authenticate_1Password() {
  report_start_phase_standard
  
  report "Time to sign into 1Password! I’ll launch it, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/1Password_how_to_log_in.md" \
    "$BUNDLE_ID_1PASSWORD" \
    "Follow the instructions in the Quick Look window to log into your 1Password account in the 1Password app"

  report_end_phase_standard
}

function interactive_basic_configure_1password() {
  report_start_phase_standard
  
  report "Time to configure basic settings for 1Password! I’ll launch it, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/1Password_how_to_basically_configure.md" \
    "$BUNDLE_ID_1PASSWORD" \
    "Follow the instructions in the Quick Look window to basically configure your 1Password app"

  report_end_phase_standard
}

function interactive_permit_1password_use_nonstandard_browsers() {
  report_start_phase_standard
  
  report "Time to add nonstandard browsers for 1Password! I’ll launch it, and open a window with instructions"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/1Password_how_to_add_nonstandard_browsers.md" \
    "$BUNDLE_ID_1PASSWORD" \
    "Follow the instructions in the Quick Look window to add nonstandard browsers to 1Password"

  report_end_phase_standard
}

function configure_and_verify_1Password_for_SSH_with_GitHub() {
  # Prompt user to configure SSH-related settings of 1Password
  
  report_start_phase_standard
  
  configure_1Password_for_ssh

  # Programmatically verify valid SSH configuration
  if ! verify_ssh_agent_configuration_for_GitHub; then
    report_fail "The attempt to configure 1Password to SSH authenticate with GitHub has failed ☹️"
    report_end_phase_standard
    return 1
  fi
  
  report success "✅ 1Password successfully configured to SSH authenticate with GitHub"
  
  report_end_phase_standard
}

function configure_1Password_for_ssh() {
  # Prompt user to configure settings of 1Password
  report_start_phase_standard
  
  report_action_taken "Time to configure 1Password for SSH with GitHub! I'll launch it, and open a window with instructions"
  
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/1Password_how_to_configure_for_ssh.md" \
    "$BUNDLE_ID_1PASSWORD" \
    "Follow the instructions in the Quick Look window to configure 1Password"

	report_end_phase_standard
}

function verify_ssh_agent_configuration_for_GitHub() {
  # Tests SSH configuration for authenticating with GitHub via SSH. Returns 0 if pass; 1 if fail
  
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
