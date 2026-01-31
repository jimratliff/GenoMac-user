#!/usr/bin/env zsh

function conditionally_interactive_ask_initial_questions() {
  report_start_phase_standard

  run_if_system_has_not_done \
    "$PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED" \
    interactive_ask_initial_questions \
    "Skipping introductory questions, because you've answered them in the past."
  
  report_end_phase_standard
}

function interactive_ask_initial_questions() {

  # Ask questions to the executing user that will guide the remainder of the Hypervisor process.
  # Typically, the answer to each true/false question depends only on the particular user,
  # not on the particular session.
  # Therefore, we ask these questions only once, the first time the user’s preferences are set
  # by GenoMac-user.

  report_start_phase_standard

  local prompt

  prompt="Does this user want to see, on the desktop, the built-in and external drives?"
  set_user_state_based_on_yes_no "$PERM_FINDER_SHOW_DRIVES_ON_DESKTOP" "$prompt"

  prompt="Will this user want to SSH authenticate GitHub using 1Password"
  set_user_state_based_on_yes_no "$PERM_1PASSWORD_USER_WANTS_TO_CONFIGURE_SSH_AGENT" "$prompt"

  prompt="Will this user sync preferences via Dropbox?"
  set_user_state_based_on_yes_no "$PERM_DROPBOX_USER_WANTS_IT" "$prompt"

  prompt="Will this user want to configure Microsoft Word?"
  set_user_state_based_on_yes_no "$PERM_MICROSOFT_WORD_USER_WANTS_IT" "$prompt"

  report_end_phase_standard

}

