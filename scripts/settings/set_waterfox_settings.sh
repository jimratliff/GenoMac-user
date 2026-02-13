#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/web_extension_data_gecko.sh"

PROFILES_PATH_WATERFOX="$HOME/Library/Application Support/Waterfox/Profiles"

function conditionally_implement_waterfox_settings_and_install_extensions() {

  report_start_phase_standard

  run_if_user_has_not_done \
    "$SESH_WATERFOX_EXTENSIONS_HAVE_BEEN_INSTALLED" \
    install_waterfox_extensions \
    "Skipping installation of Waterfox extensions, because they’ve already been installed this session"

  run_if_user_has_not_done \
    "$SESH_WATERFOX_SETTINGS_HAVE_BEEN_IMPLEMENTED" \
    implement_waterfox_preferences \
    "Skipping specifying Waterfox preferences, because they’ve already been specified this session"
	
  report_end_phase_standard
}

function install_waterfox_extensions() {
  # Install each browser extension named in environment variable STANDARD_WEB_BROWSER_EXTENSIONS_GECKO
  # into Waterfox, in disabled state.
  #
  # If Waterfox has never run (and therefore never created its directory structure), it will be
  # launched and quit.
  #
  # If already running, will be quit.
  #
  # Assumes that, for each extension xxxx in STANDARD_WEB_BROWSER_EXTENSIONS_GECKO,
  # a pair of variables GECKO_EXTENSION_xxxx_SLUG and GECKO_EXTENSION_xxxx_ID has been 
  # defined and are available to this function.
  #
  # See scripts/settings/web_extension_data_gecko.sh

  report_start_phase_standard
  report_action_taken "Install web-browser extensions into Waterfox"

  ensure_waterfox_profiles_path_exists
  quit_app_by_bundle_id_if_running "$BUNDLE_ID_WATERFOX"

  profile_dir=$(get_unique_active_Waterfox_profile)
  extensions_dir="$profile_dir/extensions"
  report_action_taken "Ensuring existence of extensions directory at ${extensions_dir}"
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

function implement_waterfox_preferences() {
	# Implement Waterfox preferences idempotently.
	#
	# Waterfox’s preferences are implemented by JavaScript `user_pref` commands in
	# the pref.js file within a user’s profile, e.g.,
	# '~/Library/Application Support/Waterfox/Profiles/abcdefgh.default-release/prefs.js',
	# abcdefgh is a string specific to the user’s profile.
	#
	# This script implements the desired preferences by, in the initial bootstrap instance,
	# appending new `user_pref` commands to the existing set (each user_pref of which either
	# adds to or overrides a prior, default user_pref command).
	#
	# The appended block begins with a start_marker comment and ends with an end_marker
	# comment.
	#
	# Subsequent runs of this script detects preexistence of a start_marker … end_marker
	# snippet and replaces it instead of appending again.
	#
	# NOTE: FAIL. The following was intended to change the default search engine to Google,
	#       but it didn’t work.
	#         // Search » Default search engine: Google
    #         user_pref("browser.urlbar.placeholderName", "Google");

  report_start_phase_standard
  report_action_taken "Configuring Waterfox preferences"

  ensure_waterfox_profiles_path_exists
  quit_app_by_bundle_id_if_running "$BUNDLE_ID_WATERFOX"

  local profile_dir=$(get_unique_active_Waterfox_profile)
  local prefs_file="$profile_dir/prefs.js"

  if [[ ! -f "$prefs_file" ]]; then
    report_fail "prefs.js not found at $prefs_file"
    return 1
  fi

  # NOTE: Do not change start_marker or end_marker! Later runs will search for exact
  #       matches of these strings.
  local start_marker="// >>> GenoMac-user preferences start <<<"
  local end_marker="// >>> GenoMac-user preferences end <<<"

  local prefs_block
  prefs_block=$(cat << 'EOF'
// General » Always check if Waterfox is your default browser? NO
user_pref("browser.shell.checkDefaultBrowser", false);

// General » Tabs » Open links in tabs instead of new windows? NO!
user_pref("browser.link.open_newwindow", 2);

// General » Tabs » Ask before closing multiple tabs? NO
user_pref("browser.tabs.warnOnClose", false);

// General » Tab Context Menu » Show copy all tab urls menu item? YES
user_pref("browser.tabs.copyallurls", true);

// General » Language and Appearance » Fonts » Default font: Palatino
user_pref("font.name.serif.x-western", "Palatino");

// General » Language and Appearance » Status Bar » Show Status Bar: YES
user_pref("browser.statusbar.enabled", true);

// General » Files and Applications » Applications » What should Waterfox do with other files? Save, don't ask
user_pref("browser.download.always_ask_before_handling_new_types", false);

// General » Browsing » Enable Picture-in-Picture video controls? NO
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

// Home » Homepage and new windows » Blank Page
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");

// Home » New Tabs » Blank Page
user_pref("browser.newtabpage.enabled", false);

// Privacy & Security » WebRTC peer connection » Do NOT enable WebRTC peer connection
user_pref("media.peerconnection.enabled", false);

// Privacy & Security » Passwords » Ask to save passwords? NO
user_pref("signon.rememberSignons", false);

// Privacy & Security » Passwords » Fill usernames and passwords automatically? NO
user_pref("signon.autofillForms", false);

// Privacy & Security » Passwords » Suggest strong passwords? NO
user_pref("signon.generation.enabled", false);

// Privacy & Security » Autofill » Do NOT save and fill addresses
user_pref("extensions.formautofill.addresses.enabled", false);

// Privacy & Security » Autofill » Do NOT save and fill payment methods
user_pref("extensions.formautofill.creditCards.enabled", false);

// Privacy & Security » Security » Enable HTTPS-Only Mode in all windows
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

// Look & Feel » Icons » Show Mac menu icons
user_pref("userChrome.icon.global_menu.mac", true);
EOF
)

  if grep -q "$start_marker" "$prefs_file"; then
    # Replace existing block
    local temp_file=$(mktemp)
    awk -v start="$start_marker" -v end="$end_marker" -v block="$prefs_block" '
      $0 == start { print; print block; skip=1; next }
      $0 == end { skip=0 }
      !skip { print }
    ' "$prefs_file" > "$temp_file"
    mv "$temp_file" "$prefs_file"
    report_action_taken "Updated existing GenoMac preferences block"
  else
    # Append new block
    cat >> "$prefs_file" << EOF

$start_marker
$prefs_block
$end_marker
EOF
    report_action_taken "Appended new GenoMac preferences block"
  fi

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
