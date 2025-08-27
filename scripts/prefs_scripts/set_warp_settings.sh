# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_warp_settings() {

report_start_phase_standard
report_action_taken "Implement Warp settings"

# Launch and quit Warp in order that it will have preferences to modify.
report_action_taken "Launch and quit Warp in order that it will have preferences to modify"
open -b com.googlecode.iterm2 # By bundle ID (more reliable than `open -a` by display name)
sleep 2
osascript -e 'quit app "Warp"';success_or_not

report_adjust_setting "Turn AI off"
# This choice can be relaxed on a user-by-user basis later
defaults write dev.warp.Warp-Stable IsAnyAIEnabled "false" ; success_or_not
# Experiment to see whether this should be a bool, even though `defaults read-type` says `-str`
#defaults write dev.warp.Warp-Stable IsAnyAIEnabled -bool false ; success_or_not

report_adjust_setting "Use ‘classic’ (more-customizable) input type"
defaults write dev.warp.Warp-Stable InputBoxTypeSetting "Classic" ; success_or_not

report_adjust_setting "Respect my custom Starship prompt"
defaults write dev.warp.Warp-Stable HonorPS1 "true" ; success_or_not

report_adjust_setting "Pin the input field to the top"
defaults write dev.warp.Warp-Stable InputMode "PinnedToTop" ; success_or_not

report_adjust_setting "Use Fira Code Nerd Font"
defaults write dev.warp.Warp-Stable FontName "FiraCode Nerd Font Mono"

report_adjust_setting "Always show the tab bar"
defaults write dev.warp.Warp-Stable WorkspaceDecorationVisibility "AlwaysShow"

report_adjust_setting "Put close button on left side of tabs"
defaults write dev.warp.Warp-Stable TabCloseButtonPosition "Left"

report_adjust_setting "Open files in a new tab"
defaults write dev.warp.Warp-Stable OpenFileLayout "NewTab"

report_adjust_setting "Do not automatically start Warp at login"
defaults write dev.warp.Warp-Stable LoginItem "false"

report_adjust_setting "Do receive desktop notifications"
defaults write dev.warp.Warp-Stable Notifications \
'{"mode":"Enabled","is_long_running_enabled":true,"long_running_threshold":'\
'{"secs":30,"nanos":0},"is_password_prompt_enabled":true,'\
'"is_agent_task_completed_enabled":true,"is_needs_attention_enabled":true,'\
'"play_notification_sound":true}'

report_end_phase_standard

}
