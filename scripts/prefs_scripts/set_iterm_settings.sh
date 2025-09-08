# This file assumes:
# - GENOMAC_HELPER_DIR is already set in the current shell to the absolute path of the directory 
#   containing helpers.sh.
# - PLISTBUDDY_PATH
# These environment variables must be defined by assign_environment_variables.sh

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_iterm_settings() {

report_start_phase_standard
report_action_taken "Implement iTerm2 settings"

domain="com.googlecode.iterm2"
ensure_plist_exists "${domain}"

local plist_path=$(plist_path_from_domain "$domain")

# Launch and quit iTerm2 in order that it will have preferences to modify.
# report_action_taken "Launch and quit iTerm2 in order that it will have preferences to modify"
# open -b com.googlecode.iterm2 # By bundle ID (more reliable than `open -a` by display name)
# sleep 2
# osascript -e 'quit app "iTerm2"';success_or_not

report_adjust_setting "Set: Open windows in same Spaces"
defaults write ${domain} RestoreWindowsToSameSpaces -bool true ; success_or_not

report_adjust_setting "Set Theme to Dark"
# The default value, Regular, corresponds to 1
defaults write ${domain} TabStyleWithAutomaticOption -int 1 ; success_or_not

report_adjust_setting "Change default font to Fira Code Nerd Font"
"${PLISTBUDDY_PATH} -c 'Set :"New Bookmarks":0:"Normal Font" "FiraCodeNFM-Reg 12"' "${plist_path}"
success_or_not

#/usr/libexec/PlistBuddy \
#  -c 'Set :"New Bookmarks":0:"Normal Font" "FiraCodeNFM-Reg 12"' "${plist_path}" ; success_or_not
#  ~/Library/Preferences/com.googlecode.iterm2.plist ; success_or_not

report_end_phase_standard

}
