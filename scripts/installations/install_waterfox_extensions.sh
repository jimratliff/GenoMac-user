#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/web_extension_data_gecko.sh"

function install_waterfox_extensions() {
  # Install each browser extension named in environment variable STANDARD_WEB_BROWSER_EXTENSIONS_GECKO
  # into Waterfox, in disabled state.
  #
  # If Waterfox has never run (and therefore never created its directory structure), it will be
  # launched and quit. If already running, it will be quit.
  #
  # Assumes that, for each extension xxxx in STANDARD_WEB_BROWSER_EXTENSIONS_GECKO,
  # a pair of variables GECKO_EXTENSION_xxxx_SLUG and GECKO_EXTENSION_xxxx_ID has been 
  # defined and is available to this function.
  #
  # See scripts/settings/web_extension_data_gecko.sh

  report_start_phase_standard
  report_action_taken "Install web-browser extensions into Waterfox"

  ensure_waterfox_profiles_path_exists
  quit_app_by_bundle_id_if_running "$BUNDLE_ID_WATERFOX"

  profile_dir=$(get_unique_active_Waterfox_profile)
  extensions_dir="$profile_dir/extensions"
  report_action_taken_to_log "Ensuring existence of extensions directory at ${extensions_dir}"
  mkdir -p "$extensions_dir"

  extensions_to_install=("${STANDARD_WEB_BROWSER_EXTENSIONS_GECKO[@]}")
  report "Extensions I will install: ${(j:, :)STANDARD_WEB_BROWSER_EXTENSIONS_GECKO}"

  for extension_name in "${extensions_to_install[@]}"; do
	slug_var="GECKO_EXTENSION_${extension_name}_SLUG"
	id_var="GECKO_EXTENSION_${extension_name}_ID"

	slug="${(P)slug_var}"
	ext_id="${(P)id_var}"

	source_url="${PATH_TO_EXTENSION_SLUG_GECKO}/${slug}/latest.xpi"
	destination="$extensions_dir/${ext_id}.xpi"

	report_action_taken "Downloading and installing extension ${extension_name} (${ext_id}) from ${source_url}"
	curl --silent --location --output "$destination" "$source_url" ; success_or_not
  done
  
  report_end_phase_standard
}
