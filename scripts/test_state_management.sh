#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

# Template for entry-point scripts

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Source required files
# safe_source "${GMU_PREFS_SCRIPTS}/install_btt_license.sh"

function test_state_management() {
  report_start_phase_standard

  local state_string_1="#1: I am happy to be here"
  local state_string_2="#2: I am not happy to be here"

  report_action_taken "Clean slate: I am resetting all state"
  delete_all_user_states
  list_user_states

  report_action_taken "I am setting: happy to be here"
  set_genomac_user_state "$state_string_1"
  list_user_states

  report_action_taken "I am removing state: happy to be here"
  delete_genomac_user_state "$state_string_1"
  list_user_states

  report_action_taken "I am removing a state that is not set: not happy to be here"
  delete_genomac_user_state "$state_string_2"
  list_user_states

  report_action_taken "I am setting: not happy to be here"
  set_genomac_user_state "$state_string_2"
  list_user_states

  report_action_taken "Clean slate: I am resetting all state"
  delete_all_user_states
  list_user_states

  report_action_taken "Test set_user_state_based_on_yes_no()"
  set_user_state_based_on_yes_no "$state_string_1" "Do you want ${state_string_1}?"
  list_user_states

  report_action_taken "Test set_user_state_based_on_yes_no()"
  set_user_state_based_on_yes_no "$state_string_2" "Do you want ${state_string_2}?"
  list_user_states
  
  report_end_phase_standard 

}

function echo_state_pair() {
  found_string_or_not "$1"
  found_string_or_not "$2"
}

function found_string_or_not() {
  local state_string="$1"
  if test_genomac_user_state "${state_string}" ; then
    echo "I found state ${state_string}"
  else
    echo "I did not find state ${state_string}"
  fi
}

function main() {
  test_state_management
}

main
