#!/usr/bin/env zs

# Fail early on unset variables or command failure
set -euo pipefail

# Template for entry-point scripts

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Source required files
# safe_source "${GMU_PREFS_SCRIPTS}/install_btt_license.sh"

function test_state_management() {
  report_start_phase_standard

  report "I am doing something important"

  local state_string_1="I am happy to be here"
  local state_string_2="I am not happy to be here"

  report_action_taken "Clean slate: I am resetting all state"
  reset_genomac_user_state
  test_genomac_user_state "$state_string_1"
  test_genomac_user_state "$state_string_2"

  report_action_taken "I am setting: happy to be here"
  set_genomac_user_state "$state_string_1"
  test_genomac_user_state "$state_string_1"
  test_genomac_user_state "$state_string_2"

  report_action_taken "I am removing state: happy to be here"
  delete_genomac_user_state "$state_string_1"
  test_genomac_user_state "$state_string_1"
  test_genomac_user_state "$state_string_2"

  report_action_taken "I am removing a state that is not set: not happy to be here"
  delete_genomac_user_state "$state_string_2"
  test_genomac_user_state "$state_string_1"
  test_genomac_user_state "$state_string_2"

  report_action_taken "I am setting: not happy to be here"
  set_genomac_user_state "$state_string_2"
  test_genomac_user_state "$state_string_1"
  test_genomac_user_state "$state_string_2"

  report_action_taken "Clean slate: I am resetting all state"
  reset_genomac_user_state
  test_genomac_user_state "$state_string_1"
  test_genomac_user_state "$state_string_2"
  
  report_end_phase_standard

}

function main() {
  test_state_management
}

main
