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
