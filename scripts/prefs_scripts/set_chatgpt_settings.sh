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

function set_chatgpt_settings() {

report_start_phase_standard
report_action_taken "Implement ChatGPT settings"

local domain="com.openai.chat"
local domain2="ChatGPTHelper"

report_adjust_setting "Set: Never automatically reset conversations"
defaults write ${domain} launcherChatResetDuration -string '{"never":{}}' ; success_or_not

report_adjust_setting "Set: Never show in menubar"
defaults write ${domain} desktopMenuBarBehavior -string '{"never":{}}' ; success_or_not

report_adjust_setting "Set: Do not suggest trending searches"
defaults write ${domain} trendingSuggestionsEnabled -bool false ; success_or_not

report_adjust_setting "Remove hotkey for chat bar in domain: ($domain)"
defaults write ${domain} KeyboardShortcuts_toggleLauncher -string '' ; success_or_not
report_adjust_setting "Remove hotkey for chat bar in domain: ($domain2)"
defaults write ${domain2} KeyboardShortcuts_toggleLauncher -string '' ; success_or_not

report_adjust_setting "Skip phone verification (These are not the droids…)"
defaults write ${domain} canSkipPhoneVerification -bool true ; success_or_not

report_end_phase_standard

}
