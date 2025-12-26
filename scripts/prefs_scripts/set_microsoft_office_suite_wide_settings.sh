# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_microsoft_office_suite_wide_settings() {

  report_start_phase_standard
  
  local domain="com.microsoft.office"
  
  report_action_taken "Set preferences that affect all Microsoft 364 Office applications"
  
  report_adjust_setting "Automatically sign in (suppressing “do you want to buy?” welcome dialog)"
  defaults write "${domain}" OfficeAutoSignIn -bool true ; success_or_not
  
  # For later implementation, after I develop a way to:
  # - in an initial bootstrap-only step, ask user for email address
  # - write that email address to ~/.config/microsoft-office/login_email.txt
  # - in this script, look for that that login_email.txt file and read the address
  # - if successfully found, use that email address in the below. Otherwise skip…
  # local microsoft_office_login_email_address
  # report_adjust_setting "Set Microsoft 365 sign-in name to be added on first launch"
  # defaults write "${domain}" OfficeActivationEmailAddress -string ${microsoft_office_login_email_address} ; success_or_not
  
  report_adjust_setting "Don’t show template gallery automatically on app launch"
  defaults write "${domain}" ShowDocStageOnLaunch -bool false ; success_or_not
  
  report_adjust_setting "Set default file location to local, not cloud-based"
  defaults write "${domain}" ShowDocStageOnLaunch -bool false ; success_or_not
  
  report_adjust_setting "Show file extensions"
  defaults write "${domain}" ShowFileExtensions -bool true ; success_or_not
  
  report_end_phase_standard

}
