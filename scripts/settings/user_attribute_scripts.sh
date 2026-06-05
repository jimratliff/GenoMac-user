#!/usr/bin/env zsh

function transfer_system_scoped_user_attribute_states_to_user_scoped() {
  # For the current user, transfer system-scoped user-attribute states for this
  # user to become user-scoped user-attribute states.
  #
  # For a given user-name/attribute pair, the (a) system-scoped state string is
  # identical to the (b) user-scoped state string. Therefore we can simply echo
  # the system-scoped string back into the user-scoped state string.
  
  report_start_phase_standard
  local short_name
  local state_prefix
  local system_scoped_state_string
  local -a system_scoped_state_strings

  # Collect system-scoped user-attribute state strings for current user
  short_name="$(short_name_of_user_from_HOME)"
  state_prefix="$(construct_state_string_for_user_and_attribute --user-only "$short_name")"
  
  _state_strings_with_prefix \
    "${state_prefix}" \
    "system"
  system_scoped_state_strings=("${reply[@]}")

  # Delete current set of user-scoped user-attribute state strings for this user.
  # This addresses the possibility that (a) a particular attribute was set in the
  # past but (b) this attribute has been deleted from system-state user-attribute
  # states. Clearing current set of user-scoped user-attribute state strings for
  # this user ensures that the new set of user-scoped user-attribute state strings
  # will mirror the system-scoped user-attribute state strings for this user.
  
  delete_all_user_states_matching_prefix "$state_prefix"

  # Save the system-scoped state strings, without transformation, as user-scoped
  # state strings.

  for system_scoped_state_string in "${system_scoped_state_strings[@]}"; do
    set_genomac_user_state "$system_scoped_state_string"
  done

  report_end_phase_standard
}
