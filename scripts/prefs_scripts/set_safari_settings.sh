# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_safari_settings() {

report_start_phase_standard
report_action_taken "Implement Safari settings"

report_adjust_setting "Do NOT auto-open “safe” downloads"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false ; success_or_not

report_adjust_setting "Always show website titles in tabs"
defaults write com.apple.Safari EnableNarrowTabs -bool false ; success_or_not

report_adjust_setting "Never automatically open a website in a tab rather than a window"
defaults write com.apple.Safari TabCreationPolicy -int 0 ; success_or_not

report_adjust_setting "Do NOT navigate tabs with ⌘1 – ⌘9"
defaults write com.apple.Safari Command1Through9SwitchesTabs -bool false ; success_or_not

report_adjust_setting "Show full website address in Smart Search field"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true ; success_or_not

report_adjust_setting "Always show tab bar"
defaults write com.apple.Safari AlwaysShowTabBar -bool true ; success_or_not

report_adjust_setting "Show favorites bar"
# Notes:
# - Each window can independently have its favorites bar shown/hidden
# - Each time the View » Show/Hide Favorites Bar menu item is chosen, "ShowFavoritesBar-v2" is updated
# - The current state of "ShowFavoritesBar-v2" dictates whether a *new* window will have its
#   favorites bar shown or hidden
# - Thus, the state of "ShowFavoritesBar-v2" in a script such as this establishes the default for the
#   first browser window opened. As long as the user doesn’t retract that setting, all windows will
#   show the favorites bar.
defaults write com.apple.Safari "ShowFavoritesBar-v2" -bool true ; success_or_not

report_adjust_setting "Show status bar"
# sudo defaults write com.apple.Safari ShowOverlayStatusBar -bool true ; success_or_not
defaults write com.apple.Safari ShowOverlayStatusBar -bool true ; success_or_not






report_end_phase_standard

}
