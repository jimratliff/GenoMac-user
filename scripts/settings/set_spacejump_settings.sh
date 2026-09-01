#!/usr/bin/env zsh

function conditionally_configure_spacejump() {
  report_start_phase_standard

  if test_genomac_user_state "$SESH_SPACEJUMP_USER_WANTS_IT"; then
    report "Skipping configuring SpaceJump because this user doesn’t want it."
    report_end_phase_standard
    return 0
  fi
  
  run_if_user_has_not_done "$SESH_SPACEJUMP_BASIC_SETTINGS_HAVE_BEEN_SET" \
    set_spacejump_basic_settings \
    "Skipping basic settings for SpaceJump, because it’s already been configured this session"
  
  run_if_user_has_not_done "$PERM_SPACEJUMP_LICENSE_HAS_BEEN_ACTIVATED" \
    activate_spacejump_license \
    "Skipping activating SpaceJump license, because this has already been done in the past"
  
  run_if_user_has_not_done "$PERM_SPACE_NAMES_HAVE_BEEN_RECORDED_BY_SPACEJUMP" \
    specify_Space_names_in_SpaceJump \
    "Skipping specifying Space names in SpaceJump because this has been done before."
  
  report_end_phase_standard
}

function specify_Space_names_in_SpaceJump() {
  # Gather list of Space names and write them to SpaceJump preferences
  report_start_phase_standard
  
  local domain="$DEFAULTS_DOMAINS_SPACEJUMP"
  local space_names_as_data

  report_action_taken "Specify Space names in SpaceJump."

  space_names_as_data="$(get_space_names_as_data)"

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_SPACEJUMP"

  plist_path="$(legacy_plist_path_from_domain $domain)"
  ensure_plist_path_exists "${plist_path}"

  defaults write $domain "spaceNamesByID" -data "$space_names_as_data" ; success_or_not

  invalidate_preferences_cache

  launch_app_by_bundle_id_in_background_hidden "$BUNDLE_ID_SPACEJUMP"

  report_end_phase_standard
}

function get_space_names_as_data() {
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard

  ############### TODO WIP!!!!!!
  report_fail "specify_Space_names_in_SpaceJump() not implemented yet!"
  return 1
  
  local space_names_as_data

  # 

  print --r "$space_names_as_data"
  
  report_end_phase_standard
}

function activate_spacejump_license() {
  # Activate license for SpaceJump
  report_start_phase_standard
  
  local domain="$DEFAULTS_DOMAINS_SPACEJUMP"
  local plist_path
  local license_key

  report_action_taken "Activate license for SpaceJump."

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_SPACEJUMP"

  plist_path="$(legacy_plist_path_from_domain $domain)"
  ensure_plist_path_exists "${plist_path}"

  local now_utc_as_type_date
  now_utc_as_type_date="$(date -u '+%Y-%m-%d %H:%M:%S +0000')"
  
  license_key="$(get_license_key_for_spacejump)"
  report_to_log "License key for SpaceJump: $license_key"

  if [[ -z "$license_key" ]]; then
    report_fail "The SpaceJump license key is empty."
    return 1
  fi

  defaults_write $domain "license_is_licensed" -bool true ; success_or_not
  defaults_write $domain "license_key" -string "$license_key" ; success_or_not
  defaults_write $domain "license_last_validation" -date "$now_utc_as_type_date" ; success_or_not

  invalidate_preferences_cache
  
  report_end_phase_standard
}

function get_license_key_for_spacejump() {
  # Retrieve license key for SpaceJump from SPACEJUMP_LICENSE_KEY_FILE.
  report_start_phase_standard

  local license_key_file="$SPACEJUMP_LICENSE_KEY_FILE"
  local license_key=""
  local line

  if [[ ! -f "$license_key_file" || ! -r "$license_key_file" ]]; then
    report_fail "SpaceJump license key file does not exist or is not readable: $license_key_file"
    return 1
  fi

  # Read contents of license_key_file, skip initial comments (i.e., beginning with '#') and initial blank lines.
  # Trim leading and trailing white space of first other line, and return residual string.
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip initial comments and blank/whitespace-only lines.
    [[ "$line" == \#* ]] && continue

    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] && continue

    license_key="$line"
    break
  done < "$license_key_file"

  if [[ -z "$license_key" ]]; then
    report_fail "No SpaceJump license key found in: $license_key_file"
    return 1
  fi

  report_to_log "License key for SpaceJump: $license_key"
  print -r -- "$license_key"

  report_end_phase_standard
}

function set_spacejump_basic_settings() {
  # Set basic settings for SpaceJump
  # These “basic settings” do not include (a) license key or (b) names
  # for each Space
  report_start_phase_standard
  
  local domain="$DEFAULTS_DOMAINS_SPACEJUMP"
  local plist_path

  plist_path="$(legacy_plist_path_from_domain $domain)"
  ensure_plist_path_exists "${plist_path}"

  report_action_taken "Implement basic settings for SpaceJump."

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_SPACEJUMP"

  report_adjust_setting "Time tracking per Space: Turn OFF"
  defaults write $domain "usage_timeTrackingEnabled" -bool false ; success_or_not

  report_adjust_setting "Move window to Space via dragging: Turn OFF"
  defaults write $domain "dragToSwitchEnabled" -bool false ; success_or_not

  report_adjust_setting "Show Space bar at top of screen when in Quick Switcher: ON"
  # (When you open the Quick Switcher, a Mission Control-style bar appears at the
  #  top of the screen showing all your spaces as miniature rectangles. Navigate
  #  with arrow keys or click directly)
  defaults write $domain "showSpaceBar" -bool true ; success_or_not

  invalidate_preferences_cache

  
  report_end_phase_standard
}
