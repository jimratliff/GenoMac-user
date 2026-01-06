#!/bin/zsh

function ask_initial_questions() {

  # Ask questions to the executing user that will guide the remainder of the Hypervisor process
  # Typically, each question is true/false based on the particular user.
  # Therefore, we ask these questions only once, the first time the user’s preferences are set
  # by GenoMac-user.

  report_start_phase_standard

  local prompt

  prompt="Does this user want to see, on the desktop, the built-in and external drives?"
  set_user_state_based_on_yes_no "$GMU_PERM_USER_SHOW_DRIVES_ON_DESKTOP" "$prompt"

  prompt="Will this user sync preferences via Dropbox?"
  set_user_state_based_on_yes_no "$GMU_PERM_USER_WILL_USE_DROPBOX" "$prompt"

  prompt="Will this user want to configure Microsoft Word?"
  set_user_state_based_on_yes_no "$GMU_PERM_USER_WILL_USE_MICROSOFT_WORD" "$prompt"

  report_end_phase_standard

}

