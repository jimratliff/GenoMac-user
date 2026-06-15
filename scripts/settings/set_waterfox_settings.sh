#!/usr/bin/env zsh

safe_source "${GMU_INSTALLATION_SCRIPTS}/install_waterfox_extensions.sh"

PROFILES_PATH_WATERFOX="$HOME/Library/Application Support/Waterfox/Profiles"

function conditionally_implement_waterfox_settings_and_install_extensions() {

  report_start_phase_standard

  run_if_user_has_not_done \
    "$SESH_WATERFOX_EXTENSIONS_HAVE_BEEN_INSTALLED" \
	# See scripts/installations/install_waterfox_extensions.sh for install_waterfox_extensions
    install_waterfox_extensions \
    "Skipping installation of Waterfox extensions, because they’ve already been installed this session"

  run_if_user_has_not_done \
    "$SESH_WATERFOX_SETTINGS_HAVE_BEEN_IMPLEMENTED" \
    implement_waterfox_preferences \
    "Skipping specifying Waterfox preferences, because they’ve already been specified this session"
	
  report_end_phase_standard
}

function implement_waterfox_preferences() {
	# Implement Waterfox preferences idempotently by copying idempotently a user.js file
	# from GenoMac-user/resources/waterfox to an appropriate destination within 
	# ~/Library/Application Support/Waterfox
	#
	# Waterfox’s preferences are implemented by JavaScript `user_pref` commands in
	# the pref.js file within a user’s profile, e.g.,
	# '~/Library/Application Support/Waterfox/Profiles/abcdefgh.default-release/prefs.js',
	# where 'abcdefgh' is an arbitrary string specific to the user’s profile.
	#
	# However, that file contains the following instructions, which are implemented here:
	#   // If you make changes to this file while the application is running,
    #   // the changes will be overwritten when the application exits.
    #   //
    #   // To change a preference value, you can either:
    #   // - modify it via the UI (e.g. via about:config in the browser); or
    #   // - set it within a user.js file in your profile.

  report_start_phase_standard
  report_action_taken "Configuring Waterfox preferences"

  ensure_waterfox_profiles_path_exists
  quit_app_by_bundle_id_if_running "$BUNDLE_ID_WATERFOX"

  local source_path="${GMU_RESOURCES}/waterfox/user.js"
  
  local profile_dir=$(get_unique_active_Waterfox_profile)
  local destination_path="$profile_dir/user.js"

  copy_resource_between_local_directories "$source_path" "$destination_path"

  report_end_phase_standard
}

function ensure_waterfox_profiles_path_exists() {
  report_start_phase_standard
  
  if [[ ! -d "$PROFILES_PATH_WATERFOX" ]]; then
    report_action_taken "Waterfox profiles path not found; launching Waterfox to create it"
    launch_and_quit_app "$BUNDLE_ID_WATERFOX"
  fi

  if [[ ! -d "$PROFILES_PATH_WATERFOX" ]]; then
    report_fail "Waterfox profiles path still not found at $PROFILES_PATH_WATERFOX after launching Waterfox"
    return 1
  fi

  report_success "Waterfox profiles path found at $PROFILES_PATH_WATERFOX"
  
  report_end_phase_standard
}

function get_unique_active_Waterfox_profile() {
	# Waterfox creates two profiles on first launch:
	# - *.default-release    <- the active profile (extensions, settings, etc.)
	# - *.68-edition-default <- vestigial, unused, never modified after creation
	#
	# We target only .default-release. If the user has created additional profiles,
	# there may be multiple matches; we treat that as an error rather than guessing.
  
	local profile_matches=$(find "${PROFILES_PATH_WATERFOX}" -maxdepth 1 -type d -name "*.default-release")
	local profile_count=$(echo "$profile_matches" | grep -c .)
	
	if [[ "$profile_count" -eq 0 ]]; then
		report_fail "Could not find Waterfox profile directory"
		return 1
	elif [[ "$profile_count" -gt 1 ]]; then
		report_fail "Error: Multiple .default-release profiles found; cannot determine which to use:${NEWLINE}$profile_matches"
		return 1
	fi

  local profile_dir="$profile_matches"
  echo "$profile_dir"
  
}
