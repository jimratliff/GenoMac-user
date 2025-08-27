# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_iterm_settings() {

report_start_phase_standard
report_action_taken "Implement iTerm2 settings"

# Launch and quit iTerm2 in order that it will have preferences to modify.
report_action_taken "Launch and quit DiskUtility in order that it will have preferences to modify"
open -b com.googlecode.iterm2 # By bundle ID (more reliable than `open -a` by display name)
sleep 2
osascript -e 'quit app "iTerm2"';success_or_not

report_adjust_setting "Set: Open windows in same Spaces"
defaults write com.googlecode.iterm2 RestoreWindowsToSameSpaces -bool true ; success_or_not

report_adjust_setting "Set Theme to Dark"
# The default value, Regular, corresponds to 1
defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 1

report_adjust_setting "Change default font to Fira Code Nerd Font"
/usr/libexec/PlistBuddy \
  -c 'Set :"New Bookmarks":0:"Normal Font" "FiraCodeNFM-Reg 12"' \
  ~/Library/Preferences/com.googlecode.iterm2.plist

report_end_phase_standard

}
