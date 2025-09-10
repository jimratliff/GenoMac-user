# Sets *general* Dock settings, not including specifying the occupants of the Dock.

# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_general_dock_settings() {

report_start_phase_standard
report_action_taken "Implement general Dock settings (but not populating the Dock with apps)"

report_adjust_setting "Dock: Turn OFF automatic hide/show the Dock"
defaults write com.apple.dock autohide -bool false;success_or_not

report_adjust_setting "Dock: Turn on magnification effect when hovering over Dock"
defaults write com.apple.dock magnification -bool true;success_or_not

report_adjust_setting "Dock: Set size of magnified Dock icons"
defaults write com.apple.dock largesize -float 128;success_or_not

report_adjust_setting "Dock: Show indicator lights for open apps"
defaults write com.apple.dock show-process-indicators -bool true;success_or_not

report_adjust_setting "Make Dock icons of hidden apps translucent"
defaults write com.apple.Dock showhidden -bool true;success_or_not

report_adjust_setting "Dock: Enable two-finger scrolling on Dock icon to reveal thumbnails of all windows for that app"
defaults write com.apple.dock scroll-to-open -bool true;success_or_not

report_adjust_setting "Minimize app to Dock rather than to app’s Dock icon"
defaults write com.apple.dock minimize-to-application -bool false;success_or_not

# This is NOT working as of 7/2/2025
# report_adjust_setting "Highlight the element of a grid-view Dock stack over which the cursor hovers"
# defaults write com.apple.dock mouse-over-hilte-stack -bool true;success_or_not

# Hot-corner settings
report_adjust_setting "Set bottom-right corner to Start Screen Saver"
defaults write com.apple.dock wvous-br-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 5 ; success_or_not

report_adjust_setting "Set bottom-left corner to Disable Screen Saver"
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 6 ; success_or_not

report_end_phase_standard

}
