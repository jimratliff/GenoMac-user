#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/web_extension_data_gecko.sh"

PROFILES_PATH_WATERFOX="$HOME/Library/Application Support/Waterfox/Profiles"

function conditionally_set_waterfox_settings() {
  # TODO: Although extensions are installed, also need to configure other settings

  report_start_phase_standard

  run_if_user_has_not_done \
    "$SESH_WATERFOX_EXTENSIONS_HAVE_BEEN_INSTALLED" \
    install_waterfox_extensions \
    "Skipping installation of Waterfox extensions, because they’ve already been installed this session"
  

  report_end_phase_standard
}

function install_waterfox_extensions() {
  # Install each web-browser extension named in STANDARD_WEB_BROWSER_EXTENSIONS_GECKO into
  # Waterfox, in disabled state.
  #
  # Waterfox, if running, will be quit.

  report_start_phase_standard
  report_action_taken "Install web-browser extensions into Waterfox"

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_WATERFOX"

  profile_dir=$(get_unique_active_Waterfox_profile)
	extensions_dir="$profile_dir/extensions"
	mkdir -p "$extensions_dir"

  extensions_to_install=("${STANDARD_WEB_BROWSER_EXTENSIONS_GECKO[@]}")

	for extension_name in "${extensions_to_install[@]}"; do
		slug_var="GECKO_EXTENSION_${extension_name}_SLUG"
		id_var="GECKO_EXTENSION_${extension_name}_ID"
		
		slug="${!slug_var}"
		ext_id="${!id_var}"

    source_url="${PATH_TO_EXTENSION_SLUG_GECKO}/${slug}/latest.xpi"
    destination="$extensions_dir/${ext_id}.xpi"

    report_action_taken "Downloading and installing extension ${extension_name} (${ext_id}) from ${source_url}"
    curl --silent --location --output "$destination" "$source_url" ; success_or_not
	done
  
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
