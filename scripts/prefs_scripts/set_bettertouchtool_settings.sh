# This file assumes:
# - GENOMAC_HELPER_DIR is already set in the current shell to the absolute path of the directory 
#   containing helpers.sh.
# - GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH is set to the path at which the preset to be autoloaded is located.
# These environment variables must be defined by assign_environment_variables.sh

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_btt_settings() {

  # As of October 2025, BTT has no reliable method for syncing its “preset” configuration 
  # across users/Macs (although the promised delivery of this feature is overdue).
  # 
  # Instead, an established preset file is deployed by GenoMac-user to a location where BTT 
  # will detect it on BTT’s launching and import it for use. By default, BTT expects the 
  # preset-to-be-autoloaded to exist at `~/.btt_autoload_preset.json`. However, we override 
  # this location to be `~/.config/BetterTouchTool/Default_preset.json` using the syntax 
  # `defaults write com.hegenberg.BetterTouchTool BTTAutoLoadPath "~/somepath"`.
  # 
  # This deployment is accomplished by GenoMac-user’s dotfile-stowing process. Hence, no 
  # separate operation need be performed here to implement this (given that the 
  # dotfile-stowing process is already part of the standard GenoMac-user workflow).
  # 
  # It is expected that BTT’s standard preset will be very stable in the sense of rarely 
  # changing. If it *does* change, see the section “Appendix: What to do when you change 
  # the BetterTouchTool preset” of the README of this repository.
  
  report_start_phase_standard
  report_action_taken "Implement BetterTouchTool settings"
  
  local domain="com.hegenberg.BetterTouchTool"
  
  report_adjust_setting "Define preset location to ${GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH}"
  defaults write ${domain} BTTAutoLoadPath "${GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH}" ; success_or_not
  
  report_end_phase_standard

}
