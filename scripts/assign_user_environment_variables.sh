#!/usr/bin/env zsh

# Establishes values for environment variables used exclusively by GenoMac-user 
#
# Assumes that export_and_report() has already been made available
#
# See also environment_variables_for_state_enums_script.sh

set -euo pipefail

GENOMAC_NAMESPACE="com.virtualperfection.genomac"

# Specify location of PlistBuddy
PLISTBUDDY_PATH='/usr/libexec/PlistBuddy'

# Establish symbolic names for modifier keys
SHIFT_CHAR=$'\u21e7'     # ⇧
CONTROL_CHAR=$'\u2303'   # ⌃  
OPTION_CHAR=$'\u2325'    # ⌥
COMMAND_CHAR=$'\u2318'   # ⌘
META_MODIFIER_CHARS="${CONTROL_CHAR}${OPTION_CHAR}${COMMAND_CHAR}"
MODIFIERS_KEYBOARD_NAVIGATION="${SHIFT_CHAR}${OPTION_CHAR}${COMMAND_CHAR}"

# Specify the local directory that holds resources (files or folders) needed for particular
# operations by GenoMac-user
GENOMAC_USER_LOCAL_RESOURCE_DIRECTORY="${GENOMAC_USER_LOCAL_DIRECTORY}/resources"

# Specify the local directory that is the “stow directory” that GNU Stow uses as
# both (a) the raw dotfiles representing various configurations and (b) the
# structural template defining where each symlink should reside in the user’s
# $HOME directory.
GENOMAC_USER_LOCAL_STOW_DIRECTORY="${GENOMAC_USER_LOCAL_DIRECTORY}/stow_directory"

# Specify the local directory into which the diff results of defaults_detective
# investigations will be saved.
GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS="$HOME/genomac-detective"

# Specify the local directory in which preferences and other files shared across users are stored
# These may contain secrets, so this directory is NOT within a repo
# E.g., this would be within each user’s Dropbox directory.
GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${GENOMAC_USER_DROPBOX_DIRECTORY}/Preferences_common"

# Specify the file name of the BetterTouchTool (BTT) preset to be auto-loaded at BTT startup
#
# TODO: Only GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH is actually used.
#       The other two are intermediate values that don’t need to be exported.
GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME="Default_preset.json"
GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY="$HOME/.config/BetterTouchTool"
GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH="${GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY}/${GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME}"

# Environment variables to support the Hypervisor
GMU_HYPERVISOR_MAKE_COMMAND_STRING="make run-hypervisor"
GMU_HYPERVISOR_HOW_TO_RESTART_STRING="To get back into the groove at any time, just reexecute ${GMU_HYPERVISOR_MAKE_COMMAND_STRING}\nand we’ll pick up where we left off."

# Export environment variables to be available in all subsequent shells
report_action_taken "Exporting environment variables to be consistently available."

# function export_and_report() {
#   local var_name="$1"
#   report "export $var_name: '${(P)var_name}'"
#   export "$var_name"
# }

export_and_report COMMAND_CHAR
export_and_report CONTROL_CHAR
export_and_report GENOMAC_NAMESPACE
export_and_report GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY
export_and_report GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME
export_and_report GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH
export_and_report GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS
export_and_report GENOMAC_USER_LOCAL_RESOURCE_DIRECTORY
export_and_report GENOMAC_USER_LOCAL_STOW_DIRECTORY
export_and_report GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY
export_and_report GMU_HYPERVISOR_HOW_TO_RESTART_STRING
export_and_report GMU_HYPERVISOR_MAKE_COMMAND_STRING
export_and_report META_MODIFIER_CHARS
export_and_report MODIFIERS_KEYBOARD_NAVIGATION
export_and_report OPTION_CHAR
export_and_report PLISTBUDDY_PATH
export_and_report SHIFT_CHAR
