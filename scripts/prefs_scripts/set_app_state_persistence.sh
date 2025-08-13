# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_app_state_persistence() {

report_start_phase_standard
report_action_taken "Implement app-state persistence"

report_adjust_setting "1 of 3: loginwindow: TALLogoutSavesState: true"
defaults write com.apple.loginwindow TALLogoutSavesState -bool true;success_or_not
report_adjust_setting "2 of 3: loginwindow: LoginwindowLaunchesRelaunchApps: true"
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool true;success_or_not
report_adjust_setting "3 of 3: NSGlobalDomain: NSQuitAlwaysKeepsWindows: true"
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true;success_or_not

# Closing a document window confirms any dirty changes
report_adjust_setting "Implement document-state persistence"
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true;success_or_not

report_end_phase_standard

}
