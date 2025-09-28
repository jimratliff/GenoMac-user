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

local domain="com.googlecode.iterm2"

local plist_path=$(legacy_plist_path_from_domain "$domain")

report_adjust_setting "Set: Open windows in same Spaces"
defaults write ${domain} RestoreWindowsToSameSpaces -bool true ; success_or_not

report_adjust_setting "Set Theme to Dark"
# The default value, Regular, corresponds to 1
defaults write ${domain} TabStyleWithAutomaticOption -int 1 ; success_or_not

# The following settings apply to the Default profile

report_adjust_setting "Change default font to Fira Code Nerd Font"

# It is insufficient to test for the existence of the plist file. The plist file can exist but yet
# not contain the entry needed to set the default font.

# iTerm’s plist is not sufficiently populated to support setting the default font unless iTerm has been launched once.
# We check whether there is a sufficiently populated plist. If not, launch iTerm to create that plist.
if ! "${PLISTBUDDY_PATH}" -c 'Print :"New Bookmarks":0:"Normal Font"' "${plist_path}" >/dev/null 2>&1; then
    report_warning $'\niTerm2 preferences not properly initialized, launching iTerm2 to properly populate plist file.'
    launch_and_quit_app "${domain}"
    sleep 2
fi

"${PLISTBUDDY_PATH}" -c 'Set :"New Bookmarks":0:"Normal Font" "FiraCodeNFM-Reg 12"' "${plist_path}" ; success_or_not

# Set number of scrollback lines to unlimited
report_adjust_setting "Set number of scrollback lines to unlimited"
"${PLISTBUDDY_PATH}" -c 'Set :"New Bookmarks":0:"Unlimited Scrollback" 1' "${plist_path}" ; success_or_not

report_end_phase_standard

}
