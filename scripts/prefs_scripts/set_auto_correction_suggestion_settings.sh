# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_auto_correction_suggestion_settings() {

########## Stop intrusive/arrogant “corrections”
# Turn off:
# - Correct spelling automatically
# - Capitalize words automatically
# - Add period with double-space
# - Use smart quotes and dashes

report_start_phase_standard
report_action_taken "Stop intrusive, arrogant, I-know-better-than-you “corrections”"

report_action_taken "Turn OFF: “Correct spelling automatically”"
report_adjust_setting "1 of 2: NSAutomaticSpellingCorrectionEnabled"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false;success_or_not
report_adjust_setting "2 of 2: WebAutomaticSpellingCorrectionEnabled"
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false;success_or_not

report_adjust_setting "Turn OFF: Capitalize words automatically"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false;success_or_not

# Turning off inline predictive text not currently chosen to be implemented, but could be:
# report_adjust_setting "Turn OFF: Show inline predictive text"
# defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false;success_or_not

# INTERESTING: Two different Macs (both running Sequoia macOS 15.5) disagree whether there is now a
# “Show suggested replies” option. My Mac Studio has it (which has been upgraded over time); 
# my pristine M1 Mac mini does not have it.

report_adjust_setting "Turn OFF: Add period with double-space"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false;success_or_not

report_action_taken "Turn OFF: Use smart quotes and dashes"
report_adjust_setting "1 of 2: I’ll supply the intelligence for my quotation marks, thank you!"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false;success_or_not
report_adjust_setting "2 of 2: Don’t automatically substitute dash/hyphen types"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false;success_or_not

report_end_phase_standard

}
