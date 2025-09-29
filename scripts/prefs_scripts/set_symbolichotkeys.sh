# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/symbolichotkeys_helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Enable and/or disable hotkey activation of particular commands.
#
# Note: For the description of what each action is associated to a particular command-id, see
# the function get_command_description() in symbolic_helpers.sh

# Assumes the following environment variables are defined in, and sourced from, assign_environment_variables.sh
# SHIFT_CHAR=$'\u21e7'     # ⇧
# CONTROL_CHAR=$'\u2303'   # ⌃  
# OPTION_CHAR=$'\u2325'    # ⌥
# COMMAND_CHAR=$'\u2318'   # ⌘
# META_MODIFIER_CHARS="${CONTROL_CHAR}${OPTION_CHAR}${COMMAND_CHAR}"

function set_symbolichotkeys() {

report_start_phase_standard
report_action_taken "Set hot-key correspondences to Apple commands"

############### Hotkeys to disable
report_action_taken "Disabling certain commands"

# Minimize a window
disable_command_by_its_id 233

# Move left a space
disable_command_by_its_id 79

# Move right a space
disable_command_by_its_id 81

# Move down a space
disable_command_by_its_id 83

# Move up a space
disable_command_by_its_id 85

# Window hotkeys to disable to (a) free up their hotkeys and (b) I’ll never use them since they
# require “Displays bave separate Spaces”
# Halves
disable_command_by_its_id 240
disable_command_by_its_id 241
disable_command_by_its_id 242
disable_command_by_its_id 243
# Quarters
disable_command_by_its_id 244
disable_command_by_its_id 245
disable_command_by_its_id 246
disable_command_by_its_id 247
# Arrange
disable_command_by_its_id 248
disable_command_by_its_id 249
disable_command_by_its_id 250
disable_command_by_its_id 251
disable_command_by_its_id 256

############### Set new hotkeys (The FOLLOWING NEED TO BE CONFIRMED)

local modifiers_for_mission_control=$META_MODIFIER_CHARS

# Activate Mission Control
assign_hotkey_to_command_id 32 "F8" $modifiers_for_mission_control

# Expose: application windows
assign_hotkey_to_command_id 33 "F10" $modifiers_for_mission_control

# Show Desktop
assign_hotkey_to_command_id 36 "F11" $modifiers_for_mission_control

# Show Notification Center
assign_hotkey_to_command_id 163 "F9" $modifiers_for_mission_control

# Set hotkeys to move to a new space by number of the space 1–16
assign_hotkey_to_command_id 118 "1" $modifiers_for_mission_control
assign_hotkey_to_command_id 119 "2" $modifiers_for_mission_control
assign_hotkey_to_command_id 120 "3" $modifiers_for_mission_control
assign_hotkey_to_command_id 121 "4" $modifiers_for_mission_control
assign_hotkey_to_command_id 122 "5" $modifiers_for_mission_control
assign_hotkey_to_command_id 123 "6" $modifiers_for_mission_control
assign_hotkey_to_command_id 124 "7" $modifiers_for_mission_control
assign_hotkey_to_command_id 125 "8" $modifiers_for_mission_control
assign_hotkey_to_command_id 126 "9" $modifiers_for_mission_control
assign_hotkey_to_command_id 127 "0" $modifiers_for_mission_control
assign_hotkey_to_command_id 128 "F1" $modifiers_for_mission_control
assign_hotkey_to_command_id 129 "F2" $modifiers_for_mission_control
assign_hotkey_to_command_id 130 "F3" $modifiers_for_mission_control
assign_hotkey_to_command_id 131 "F4" $modifiers_for_mission_control
assign_hotkey_to_command_id 132 "F5" $modifiers_for_mission_control
assign_hotkey_to_command_id 133 "F6" $modifiers_for_mission_control

report_end_phase_standard

}
