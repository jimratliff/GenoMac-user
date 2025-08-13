# For SysAdmin users (USER_VANILLA & USER_CONFIGURER), implements settings that diverge from choices for
# generic non-SysAdmin users. Thus, this is intended to be run only after implementing settings for
# generic non-SysAdmin users.

# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function overrides_for_sysadmin_users() {
# Implements preferences for the SysAdmin users (USER_VANILLA and USER_CONFIGURER) that diverge
# from preferences set for generic non-SysAdmin users.
# Thus this function must not be executed before the preferences for generic non-sysadmin users are set.

report_start_phase_standard
report_action_taken "Overriding certain settings in a way appropriate for only SysAdmin accounts"

# Finder: Show hard drives on desktop
report_adjust_setting "Show hard drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true;success_or_not

# Finder: Show external drives on desktop (reinforces default)
report_adjust_setting "Show external drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true;success_or_not

report_action_taken "Sysadmin overrides completed. Please relaunch Finder."

# TODO: This winds up killing Finder twice. A better solutions should be sought, where each script
# appends to a list of apps that need to be killed.

# report_about_to_kill_app "Finder"
# killall "Finder";success_or_not

report_end_phase_standard

}
