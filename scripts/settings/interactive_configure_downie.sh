#!/usr/bin/env zsh

function conditionally_interactive_configure_Downie() {
  # Conditionally interactively configures Downie.

  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_DOWNIE_USER_WANTS_IT"; then
    report_to_log "Skipping configuring Downie, because user doesn’t use Downie."
    report_end_phase_standard
    return 0
  fi

  run_if_user_has_not_done "$PERM_DOWNIE_HAS_BEEN_BOOTSTRAPPED" \
    interactive_configure_Downie \
    "Skipping configuring Downie, because it’s been configured in the past"
  
  report_end_phase_standard
  
}

function interactive_configure_Downie() {
  # Interactively configures Downie settings.
  report_start_phase_standard
  
  report "Time to configure Downie! I’ll launch it, and open a window with instructions for next steps"

  create_directory_for_Downie_downloads
  set_scriptable_settings_for_Downie

  # HINT: DIRECTORY_FOR_DOWNIE_DOWNLOADS="$HOME/Documents/Downie_downloads"
  local parent_directory_for_downie_downloads
  parent_directory_for_downie_downloads=${DIRECTORY_FOR_DOWNIE_DOWNLOADS:h}

  # Open the *parent* of DIRECTORY_FOR_DOWNIE_DOWNLOADS. By opening this container folder,
  # the executing user can drag the `Downie_download` folder icon
  # into the Open-file dialog presented.

  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Downie_how_to_configure.md" \
    --open "$parent_directory_for_downie_downloads" \
    "$BUNDLE_ID_DOWNIE" \
    "Follow the instructions in the Quick Look window to configure Downie"
  
  report_end_phase_standard
}

function set_scriptable_settings_for_Downie() {
  # Sets scriptable settings for Downie app.
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
