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

report_action_taken "Turn AI off"
# This choice can be relaxed on a user-by-user basis later
# defaults write dev.warp.Warp-Stable IsAnyAIEnabled -str "false" ; success_or_not
# Experiment to see whether this should be a bool, even though `defaults read-type` says `-str`
defaults write dev.warp.Warp-Stable IsAnyAIEnabled -bool false ; success_or_not

report_action_taken "Use ‘classic’ (more-customizable) input type"
defaults write dev.warp.Warp-Stable InputBoxTypeSetting -str "Classic" ; success_or_not

report_action_taken "Respect my custom Starship prompt"
defaults write dev.warp.Warp-Stable HonorPS1 -str "true" ; success_or_not

report_action_taken "Pin the input field to the top"
defaults write dev.warp.Warp-Stable InputMode -str "PinnedToTop" ; success_or_not

report_action_taken "Use Fira Code Nerd Font"
defaults write dev.warp.Warp-Stable FontName -str "FiraCode Nerd Font Mono"

report_action_taken "Always show the tab bar"
defaults write dev.warp.Warp-Stable WorkspaceDecorationVisibility -str "AlwaysShow"

report_action_taken "Put close button on left side of tabs"
defaults write dev.warp.Warp-Stable TabCloseButtonPosition -str "Left"

report_action_taken "Open files in a new tab"
defaults write dev.warp.Warp-Stable OpenFileLayout -str "NewTab"

report_action_taken "Do not automatically start Warp at login"
defaults write dev.warp.Warp-Stable LoginItem -str "false"

report_action_taken "Do receive desktop notifications"
defaults write dev.warp.Warp-Stable Notifications \
'{"mode":"Enabled","is_long_running_enabled":true,"long_running_threshold":'\
'{"secs":30,"nanos":0},"is_password_prompt_enabled":true,'\
'"is_agent_task_completed_enabled":true,"is_needs_attention_enabled":true,'\
'"play_notification_sound":true}'

report_end_phase_standard

}
