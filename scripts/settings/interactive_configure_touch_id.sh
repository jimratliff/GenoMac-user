#!/usr/bin/env zsh

function conditionally_interactive_configure_touch_ID() {
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_TOUCH_ID_USER_WANTS_IT"; then
    report_to_log "Skipping configuring Touch ID because the user doesn’t want it."
    return 0
  fi
    
  run_if_user_has_not_done "$PERM_TOUCH_ID_HAS_BEEN_CONFIGURED" \
    interactive_configure_touch_ID \
    "Skipping configuring Touch ID because this has already been done."
  
  report_end_phase_standard
}

function interactive_configure_touch_ID() {
  ############### TODO WIP
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard
  report_end_phase_standard
}

function set_SESH_state_for_user_touch_id_choice_from_attribute_name() {
  # Sets SESH state to record user’s Touch ID finger choice.
  #
  # Expects the supplied touchid-choice attribute name to be encoded like 'touchid_R2'
  # to imply the Right #2 finger.
  report_start_phase_standard
  local attribute_name="${1:?MISSING attribute_name}"

  local state_string
  local touch_id_choice
  
  touch_id_choice="$(get_touch_id_choice_from_touchid_attribute_name "$attribute_name")"
  state_string="${SESH_TOUCH_ID_CHOICE_PREFIX}${touch_id_choice}"
  set_genomac_user_state "$state_string"
  
  report_end_phase_standard
}

function get_touch_id_choice_from_touchid_attribute_name() {
  # Returns (prints to stdout) the user’s choice of Touch ID finger encoded in the
  # 'touchid_R2' (for example) supplied attribute name.
  #
  # HINT: USER_ATTRIBUTE_TOUCH_ID_PREFIX="touchid_"
  report_start_phase_standard
  local attribute_name="${1:?MISSING attribute_name}"

  local touch_id_choice
  touch_id_choice="${attribute_name#"${USER_ATTRIBUTE_TOUCH_ID_PREFIX}"}"
  print -- "$touch_id_choice"
  
  report_end_phase_standard
}
