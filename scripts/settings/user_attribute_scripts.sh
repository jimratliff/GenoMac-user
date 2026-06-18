#!/usr/bin/env zsh

function set_user_preferences_for_attribute() {
  # Sets preference flags for the supplied attribute
  report_start_phase_standard
  local attribute_name
  attribute_name="${1:?MISSING/EMPTY attribute_name}"

  local is_developer=false

  case "$attribute_name" in
    "${USER_ATTRIBUTE_TOUCH_ID_PREFIX}"*)
      # touchid attributes are encoded with a suffix signalling which finger that user
      # is assigned. Thus, we match the attribute name only against its common prefix.
      #
      # HINT: USER_ATTRIBUTE_TOUCH_ID_PREFIX="touchid${GENOMAC_STATE_STRING_DELIMITER_X}"
      # HINT: GENOMAC_STATE_STRING_DELIMITER_X="¶∞§"
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_TOUCH_ID_PREFIX}*"
      set_genomac_user_state "$SESH_TOUCH_ID_USER_WANTS_IT"
      set_SESH_state_for_user_touch_id_choice_from_attribute_name "$attribute_name"
      ;;
    "${USER_ATTRIBUTE_CHESSPLAYER}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_CHESSPLAYER}"
      set_genomac_user_state "$SESH_HIARCS_CHESS_EXPLORER_PRO_USER_WANTS_IT"

      # NOTE: SESH_CHESSVISION_AI_USER_WANTS_IT and PERM_CHESSVISION_AI_HAS_BEEN_CONFIGURED are
      #       not currently used. Configuring Chessvision currently is so lightweight that it’s
      #       not worth carving it out in order to conditionally skip it.
      set_genomac_user_state "$SESH_CHESSVISION_AI_USER_WANTS_IT"
      ;;
    "${USER_ATTRIBUTE_DEVELOPER}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_DEVELOPER}"
      is_developer=true
      ;;
    "${USER_ATTRIBUTE_DROPBOX}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_DROPBOX}"
      set_genomac_user_state "$SESH_DROPBOX_USER_WANTS_IT"
      ;;
    "${USER_ATTRIBUTE_EMAILER}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_EMAILER}"
      set_genomac_user_state "$SESH_APPLE_MAIL_APP_USER_WANTS_IT"
      ;;
    "${USER_ATTRIBUTE_GENOMAC_DEVELOPER}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_GENOMAC_DEVELOPER}"
      set_genomac_user_state "$SESH_USER_IS_A_GENOMAC_DEVELOPER"
      is_developer=true
      ;;
    "${USER_ATTRIBUTE_MAC_ADMIN}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_MAC_ADMIN}"
      set_genomac_user_state "$SESH_FINDER_SHOW_DRIVES_ON_DESKTOP"
      ;;
    "${USER_ATTRIBUTE_MICROSOFT_WORD}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_MICROSOFT_WORD}"
      set_genomac_user_state "$SESH_MICROSOFT_WORD_USER_WANTS_IT"
      ;;
    "${USER_ATTRIBUTE_OBSIDIAN_USER}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_OBSIDIAN_USER}"
      set_genomac_user_state "$SESH_OBSIDIAN_USER_WANTS_IT"
      ;;
    "${USER_ATTRIBUTE_RAINDROP_IO}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_RAINDROP_IO}"
      set_genomac_user_state "$SESH_RAINDROP_IO_USER_WANTS_IT"
      ;;
    "${USER_ATTRIBUTE_SYNC_COM}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_SYNC_COM}"
      set_genomac_user_state "$SESH_SYNC_COM_USER_WANTS_IT"
      ;;
    "${USER_ATTRIBUTE_YOUTUBE_WATCHER}")
      report_action_taken_to_log "Setting preferences for attribute: ${USER_ATTRIBUTE_YOUTUBE_WATCHER}"
      set_genomac_user_state "$SESH_WATERFOX_EXTENSION_YOUTUBE_ENHANCER_USER_WANTS_IT"
      ;;
    *)
      report_warning "No user-preference behavior is defined for attribute: $attribute_name"
      ;;
  esac

  if [[ "$is_developer" == "true" ]]; then
    report_action_taken_to_log "Turn on flags for Git and GitHub configuration."
    set_genomac_user_state "$SESH_USER_WANTS_TO_COMMIT_ON_GITHUB"
    set_genomac_user_state "$SESH_1PASSWORD_USER_WANTS_TO_CONFIGURE_SSH_AGENT"
    set_genomac_user_state "$SESH_REPOSITORIES_DIRECTORY_USER_WANTS_IT"
  fi
    
  report_end_phase_standard
}

function set_user_preferences_from_attributes() {
  # Sets preference flags based on user’s user attributes
  report_start_phase_standard
  local attribute_name
  local short_name
  local state_prefix
  local user_scoped_state_string

  local -a user_scoped_state_strings

  # Collect user-scoped user-attribute state strings for current user
  short_name="$(short_name_of_user_from_HOME)"
  state_prefix="$(construct_state_string_for_user_and_attribute --user-only "$short_name")"
  
  _state_strings_with_prefix \
    "${state_prefix}" \
    "user"
  user_scoped_state_strings=("${reply[@]}")

  for user_scoped_state_string in "${user_scoped_state_strings[@]}"; do
    attribute_name="$(get_attribute_name_from_user_attribute_state_string "$user_scoped_state_string")"
    set_user_preferences_for_attribute "$attribute_name"
  done

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

  # Collect system-scoped user-attribute state strings for current user
  short_name="$(short_name_of_user_from_HOME)"
  state_prefix="$(construct_state_string_for_user_and_attribute --user-only "$short_name")"
  
  _state_strings_with_prefix \
    "${state_prefix}" \
    "system"
  system_scoped_state_strings=("${reply[@]}")

  # Delete current set of user-scoped user-attribute state strings for this user.
  #   This addresses the possibility that (a) a particular attribute was set in the
  #   past but (b) this attribute has been deleted from system-state user-attribute
  #   states. Clearing current set of user-scoped user-attribute state strings for
  #   this user ensures that the new set of user-scoped user-attribute state strings
  #   will mirror the system-scoped user-attribute state strings for this user.
  delete_all_user_states_matching_prefix "$state_prefix"    # GenoMac-shared/scripts/helpers-state.sh

  # Save the system-scoped state strings, without transformation, as user-scoped
  # state strings.
  for system_scoped_state_string in "${system_scoped_state_strings[@]}"; do
    set_genomac_user_state "$system_scoped_state_string"
  done

  report_end_phase_standard
}
