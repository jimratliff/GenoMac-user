#!/usr/bin/env zsh

# Establishes values for environment variables used exclusively by GenoMac-user 

set -euo pipefail



# Resolve directory of the current script
this_script_path="${0:A}"
this_script_dir="${this_script_path:h}"

# Specify the directory in which the `helpers.sh` file lives.
# E.g., when `helpers.sh` lives at the same level as this script:
# GENOMAC_HELPER_DIR="${this_script_dir}"
GENOMAC_HELPER_DIR="${this_script_dir}"

# Print assigned paths for diagnostic purposes
printf "\n📂 Path diagnostics:\n"
printf "this_script_dir:                  %s\n" "$this_script_dir"
printf "GENOMAC_HELPER_DIR:               %s\n" "$GENOMAC_HELPER_DIR"

# Source the helpers script
source "${GENOMAC_HELPER_DIR}/helpers.sh"

GENOMAC_NAMESPACE="com.virtualperfection.genomac"



############### CONJECTURE: The following is used only by GenoMac-system

# Specify URL for cloning the public GenoMac-system repository using HTTPS
GENOMAC_SYSTEM_REPO_URL="https://github.com/jimratliff/GenoMac-system.git"

# Specify local directory into which the GenoMac-system repository will be 
# cloned
# Note: This repo is cloned only by USER_CONFIGURER.
GENOMAC_SYSTEM_LOCAL_DIRECTORY="$HOME/.genomac-system"

############### CONJECTURE: The following is used only by GenoMac-user

# Specify location of PlistBuddy
PLISTBUDDY_PATH='/usr/libexec/PlistBuddy'

# Establish symbolic names for modifier keys
SHIFT_CHAR=$'\u21e7'     # ⇧
CONTROL_CHAR=$'\u2303'   # ⌃  
OPTION_CHAR=$'\u2325'    # ⌥
COMMAND_CHAR=$'\u2318'   # ⌘
META_MODIFIER_CHARS="${CONTROL_CHAR}${OPTION_CHAR}${COMMAND_CHAR}"
MODIFIERS_KEYBOARD_NAVIGATION="${SHIFT_CHAR}${OPTION_CHAR}${COMMAND_CHAR}"

# Specify local directory that will retain state information about run-only-once operations
GENOMAC_USER_LOCAL_STATE_DIRECTORY="${GENOMAC_USER_LOCAL_DIRECTORY}-state"

# Specify the local directory that holds resources (files or folders) needed for particular
# operations
GENOMAC_USER_LOCAL_RESOURCE_DIRECTORY="${GENOMAC_USER_LOCAL_DIRECTORY}/resources"

# Specify the local directory that is the “stow directory” that GNU Stow uses as
# both (a) the raw dotfiles representing various configurations and (b) the
# structural template defining where each symlink should reside in the user’s
# $HOME directory.
GENOMAC_USER_LOCAL_STOW_DIRECTORY="${GENOMAC_USER_LOCAL_DIRECTORY}/stow_directory"

# Specify the local directory into which the diff results of defaults_detective
# investigations will be saved.
GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS="$HOME/genomac-detective"

# Specify the location of the user’s `Dropbox` directory
GENOMAC_USER_DROPBOX_DIRECTORY="$HOME/Library/CloudStorage/Dropbox"

# Specify the local directory in which preferences and other files shared across users are stored
# These may contain secrets, so this directory is NOT within a repo
# E.g., this would be within each user’s Dropbox directory.
GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${GENOMAC_USER_DROPBOX_DIRECTORY}/Preferences_common"

# Specify the file name of the BetterTouchTool (BTT) preset to be auto-loaded at BTT startup
GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME="Default_preset.json"
GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY="$HOME/.config/BetterTouchTool"
GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH="${GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY}/${GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME}"

# Export environment variables to be available in all subsequent shells
report_action_taken "Exporting environment variables to be consistently available."

function export_and_report() {
  local var_name="$1"
  report "export $var_name: '${(P)var_name}'"
  export "$var_name"
}

export_and_report COMMAND_CHAR
export_and_report CONTROL_CHAR

export_and_report GENOMAC_HELPER_DIR
export_and_report GENOMAC_NAMESPACE

export_and_report GENOMAC_SYSTEM_LOCAL_DIRECTORY

export_and_report GENOMAC_SYSTEM_REPO_URL
export_and_report GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY
export_and_report GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME
export_and_report GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH
export_and_report GENOMAC_USER_DROPBOX_DIRECTORY
export_and_report GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS
export_and_report GENOMAC_USER_LOCAL_DIRECTORY
export_and_report GENOMAC_USER_LOCAL_RESOURCE_DIRECTORY
export_and_report GENOMAC_USER_LOCAL_STATE_DIRECTORY
export_and_report GENOMAC_USER_LOCAL_STOW_DIRECTORY

export_and_report GENOMAC_USER_REPO_URL
export_and_report GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY

export_and_report META_MODIFIER_CHARS
export_and_report MODIFIERS_KEYBOARD_NAVIGATION
export_and_report OPTION_CHAR
export_and_report PLISTBUDDY_PATH
export_and_report SHIFT_CHAR
