#!/usr/bin/env zsh

function conditionally_bootstrap_and_maintain_Downie() {
  # Bootstraps and maintains Downie by (a) creating directory to serve as destination for downloads
  # and (b) using defaults write to initialize preferences and inhibit the startup wizard.

  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_DOWNIE_USER_WANTS_IT"; then
    report_to_log "Skipping bootstrapping/maintaining Downie, because user doesn’t use Downie."
    report_end_phase_standard
    return 0
  fi

  

  if test_genomac_user_state "$PERM_DOWNIE_HAS_BEEN_BOOTSTRAPPED"; then
    report_to_log "Skipping bootstrapping Downie, because this has been performed in the past."
  else
    bootstrap_Downie
    report_end_phase_standard
    return 0
  fi

  set_Downie_non_bootstrap_settings

  report_end_phase_standard
  
}

function bootstrap_Downie() {
  # Bootstraps Downie
  report_start_phase_standard

  create_directory_for_Downie_downloads
  set_bootstrap_settings_for_Downie
  set_genomac_user_state "$PERM_DOWNIE_HAS_BEEN_BOOTSTRAPPED"
  
  report_end_phase_standard
}

function set_bootstrap_settings_for_Downie() {
  # Sets bootstrap settings for Downie app.
  #
  # HINT: DEFAULTS_DOMAINS_DOWNIE_4="com.charliemonroe.Downie-4"

  report_start_phase_standard

  local domain
  local plist_path
  local time_earlier
  local time_now

  domain="$DEFAULTS_DOMAINS_DOWNIE_4"
  plist_path=$(sandboxed_plist_path_from_domain $domain")

  ensure_plist_path_exists "$plist_path"

  # Inhibit initial wizard
  defaults write "$domain" XUDownie4FirstLaunch -boolean true

  set_Downie_non_bootstrap_settings
  
  
  report_end_phase_standard
}

function set_Downie_non_bootstrap_settings() {
  # Sets basic settings for Downie
  #
  # HINT: DEFAULTS_DOMAINS_DOWNIE_4="com.charliemonroe.Downie-4"
  
  report_start_phase_standard
  
  local domain
  domain="$DEFAULTS_DOMAINS_DOWNIE_4"

  # Sort downloads into subfolders by host
  defaults write "$domain" XUSortFilesByHost -boolean true

  
  report_end_phase_standard
}

function create_directory_for_Downie_downloads() {
  # Creates directory to serve as destination for downloads from Downie app.
  #
  # HINT: DIRECTORY_FOR_DOWNIE_DOWNLOADS="$HOME/Documents/Downie_downloads"

  report_start_phase_standard

  report_action_taken_to_log "Create directory to serve as destination for downloads from Downie app: “${DIRECTORY_FOR_DOWNIE_DOWNLOADS}”"
  mkdir -p "$DIRECTORY_FOR_DOWNIE_DOWNLOADS"
  
  report_action_taken_to_log "Set permissions on Downie-downloads directory"
  chmod 700 "$DIRECTORY_FOR_DOWNIE_DOWNLOADS"
  
  report_end_phase_standard
}
