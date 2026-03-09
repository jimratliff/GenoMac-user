#!/usr/bin/env zsh

function conditionally_interactive_ask_initial_questions() {

  # Ask questions to the executing user that will guide the remainder of the Hypervisor process.
  # Typically, the answer to each true/false question depends only on the particular user,
  # not on the particular session.
  # Therefore, we ask these questions only once, the first time the user’s preferences are set
  # by GenoMac-user.

  report_start_phase_standard

  conditionally_ask_question_and_assign_user_state_if_yes \
    "$PERM_Q_ASKED_FINDER_SHOW_DRIVES_ON_DESKTOP" \
    "Skipping asking about showing drives on desktop, because already answered." \
    "Does this user want to see, on the desktop, the built-in and external drives?" \
    "$PERM_FINDER_SHOW_DRIVES_ON_DESKTOP"

  conditionally_ask_question_and_assign_user_state_if_yes \
    "$PERM_Q_ASKED_CONFIGURE_YOUTUBE_ENHANCER_FOR_WATERFOX" \
    "Skipping asking about Enhancer for YouTube extension for Waterfox, because already answered." \
    "Does this user want to configure the Enhancer for YouTube browser extension for Waterfox?" \
    "$PERM_WATERFOX_EXTENSION_YOUTUBE_WANTS_TO_CONFIGURE"

  conditionally_ask_question_and_assign_user_state_if_yes \
    "$PERM_Q_ASKED_WANT_SSH_AUTHENTICATE_GITHUB_USING_1PASSWORD" \
    "Skipping asking about using 1Password to authenticate GitHub, because already answered." \
    "Will this user want to SSH authenticate GitHub using 1Password?" \
    "$PERM_1PASSWORD_USER_WANTS_TO_CONFIGURE_SSH_AGENT"

  conditionally_ask_question_and_assign_user_state_if_yes \
    "$PERM_Q_ASKED_WANT_DROPBOX" \
    "Skipping asking about using Dropbox, because already answered." \
    "Will this user sync preferences via Dropbox?" \
    "$PERM_DROPBOX_USER_WANTS_IT"

  conditionally_ask_question_and_assign_user_state_if_yes \
    "$PERM_Q_ASKED_WANT_MICROSOFT_WORD" \
    "Skipping asking about using Microsoft Word, because already answered." \
    "Will this user want to configure Microsoft Word?" \
    "$PERM_MICROSOFT_WORD_USER_WANTS_IT"

  report_end_phase_standard
}

function conditionally_ask_question_and_assign_user_state_if_yes() {
	local state_after_question_is_asked="$1"
	local skip_message="$2"
	local prompt="$3"
	local state_if_yes="$4"

	run_func_and_args_if_user_has_not_done \
	  "$state_after_question_is_asked" \
	  "$skip_message" \
	  set_user_state_based_on_yes_no \
	  "$prompt" \
	  "$state_if_yes"
}
