#!/usr/bin/env zsh

function set_bookmarkbar_settings() {

  report_start_phase_standard
  report_action_taken "Implement Bookmark Bar settings"

  local domain="$HOME/Library/Group Containers/group.org.ottomobile.bookmarkbar/Library/Preferences/group.org.ottomobile.bookmarkbar"

  report_adjust_setting "Set: Show Favicons"
  defaults write ${domain} showFavicons -bool true ; success_or_not

  report_adjust_setting "Set: isProApp"
  defaults write ${domain} isProApp -bool true ; success_or_not

  report_adjust_setting "Set: Enabled browser list"
  defaults write "${domain}" enabledBrowsers -array \
	"net.imput.helium" \
	"com.apple.Safari" \
	"com.charliemonroe.Downie-4" \
	"com.google.Chrome" \
	"org.mozilla.firefox" \
	"net.waterfox.waterfox"

  # Invalidate preferences cache to ensure our changes won’t be overwritten by cached values
  invalidate_preferences_cache

  report_end_phase_standard

}

function conditionally_install_reference_copy_bookmarkbar_bookmarks() {
  # Bootstraps Bookmark Bar’s bookmarks. (Requires Dropbox.)
  report_start_phase_standard
  run_if_user_has_not_done \
    "$PERM_BOOKMARKBAR_BOOKMARKS_WERE_COPIED_DROPBOX_TO_LIBRARY" \
      install_reference_copy_bookmarkbar_bookmarks \
      "Skipping installing Bookmark Bar reference bookmarks, because this was done in the past."
  report_end_phase_standard
}

function install_reference_copy_bookmarkbar_bookmarks() {
  report_start_phase_standard

  if [[ ! -e "$BOOKMARKBAR_REFERENCE_BOOKMARKS_SOURCE" ]]; then
    report_to_log "Skipping installing Boorkmark Bar bookmarks because no reference bookmarks file was found at ${BOOKMARKBAR_REFERENCE_BOOKMARKS_SOURCE}."
    report_end_phase_standard
    return 0
  fi

  if [[ ! -f "$BOOKMARKBAR_REFERENCE_BOOKMARKS_SOURCE" ]]; then
    report_fail "Bookmark Bar reference bookmarks path is not a file: $BOOKMARKBAR_REFERENCE_BOOKMARKS_SOURCE"
    return 1
  fi

  local bookmarkbar_is_running=false

  if app_is_running "$BUNDLE_ID_BOOKMARKBAR"; then
    bookmarkbar_is_running=true
  fi

  mkdir -p -- "$BOOKMARKBAR_PREFS_BOOKMARKS_DIRECTORY"

  # Backup any existing bookmarks file at destination
  if [[ -e "$BOOKMARKBAR_BOOKMARKS_DESTINATION" ]]; then
    copy_resource_between_local_directories \
      "$BOOKMARKBAR_BOOKMARKS_DESTINATION" \
      "$BOOKMARKBAR_BOOKMARKS_BACKUP_DESTINATION"
  fi

  # Copy reference bookmarks file to destination
  copy_resource_between_local_directories \
    "$BOOKMARKBAR_REFERENCE_BOOKMARKS_SOURCE" \
    "$BOOKMARKBAR_BOOKMARKS_DESTINATION"

  if [[ $bookmarkbar_is_running == true ]]; then
    launch_app_by_bundle_id_in_background_hidden "$BUNDLE_ID_BOOKMARKBAR"
  fi

  report_end_phase_standard
}
