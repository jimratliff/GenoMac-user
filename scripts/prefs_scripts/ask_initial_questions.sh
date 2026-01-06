#!/bin/zsh

function ask_initial_questions() {

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

function set_user_state_based_on_yes_no() {
  # Takes two string arguments
  #   $1: state_hey
  #   $2: yes/no question
  # If the user’s answer to the yes/no question is “yes”, set the state `start_key`; 
  # otherwise, do nothing.
  local state_key="$1"
  local question="$2"
  if get_yes_no_answer_to_question "$question"; then
    set_genomac_user_state "$state_key"
  fi
  return 0

}
