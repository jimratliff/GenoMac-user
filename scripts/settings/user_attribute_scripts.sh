#!/usr/bin/env zsh

function set_user_preferences_from_attributes() {
  # WIP TODO
  # Sets preference flags based on user’s user attributes
  report_start_phase_standard
  report_end_phase_standard
}

function transfer_system_scoped_user_attribute_states_to_user_scoped() {
  # For the current user, transfer system-scoped user-attribute states for this
  # user to become user-scoped user-attribute states.
  #
  # For a given user-name/attribute pair, the (a) system-scoped state string is
  # identical to the (b) user-scoped state string. Therefore we can simply echo
  # the system-scoped string back into the user-scoped state string.
  #
  # TODO: Why am I transferring these system-scoped user-attribute state files to
  #       become user-scoped state files—when I’m not then deleting the
  #       system-scoped state files (as I had originally intended but changed my
  #       mind so that user attributes can be updated by GenoMac-system over time)?
  #       It seems like I could just as easily read the system-scoped state filese
  #       directly when harvesting a user’s user attributes.
  
  report_start_phase_standard
  local short_name
  local state_prefix
  local system_scoped_state_string
  local -a system_scoped_state_strings

  ############### TODO
  # I also need to transfer:
  # - USER_HAS_ATTRIBUTE∞§¶shortname¶§∞
  # - USER_CLASS∞§¶shortname¶§∞user_class§∞¶

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
  
  delete_all_user_states_matching_prefix "$state_prefix"    # GenoMac-shared/scripts/helpers-state.sh

  # Save the system-scoped state strings, without transformation, as user-scoped
  # state strings.

  for system_scoped_state_string in "${system_scoped_state_strings[@]}"; do
    set_genomac_user_state "$system_scoped_state_string"
  done

  report_end_phase_standard
}
