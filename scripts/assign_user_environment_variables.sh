#!/usr/bin/env zsh

# Establishes values for environment variables used exclusively by GenoMac-user
#
# Intended to be sourced by scripts/0_initialize_me_first.sh
#
# Assumes that export_and_report() has already been made available
#
# See also environment_variables_for_state_enums_script.sh

#############################################
#                  Aliases to intra-repository hierarchical structures
#
############### Local directory into which the GenoMac-user repo is cloned
# ~/.genomac-user
# Defined in GenoMac-shared/scripts/assign_common_environment_variables.sh
# GENOMAC_USER_LOCAL_DIRECTORY="$HOME/.genomac-user"

############### ~/.genomac-user/resources
# Local directory that holds resources (files or folders) needed for particular
# operations by GenoMac-user, typically personalized resources that are not shell scripts
# and not otherwise available online
GMU_RESOURCES="${GENOMAC_USER_LOCAL_DIRECTORY}/resources"

# Specify the local directory that holds documentation files to display to the executing user
# ~/.genomac-user/resources/docs_to_display_to_user
GMU_DOCS_TO_DISPLAY="${GMU_RESOURCES}/docs_to_display_to_user"

############### ~/.genomac-user/scripts
# - Local directory that holds scripts: ~/.genomac-user/scripts
GMU_SCRIPTS="${GENOMAC_USER_LOCAL_DIRECTORY}/scripts"

# ~/.genomac-user/scripts/hypervisor
# - Local subdirectory of GMU_SCRIPTS that holds scripts specific to Hypervisor
GMU_HYPERVISOR_SCRIPTS="${GMU_SCRIPTS}/hypervisor" 

# ~/.genomac-user/scripts/settings
GMU_SETTINGS_SCRIPTS="${GMU_SCRIPTS}/settings"

############### ~/.genomac-user/utilities
# Holds narrow-focused scripts to be individually accessed by make recipes
GMU_UTILITIES="${GENOMAC_USER_LOCAL_DIRECTORY}/utilities"

##############################

# Specify location of PlistBuddy
PLISTBUDDY_PATH='/usr/libexec/PlistBuddy'

# Establish symbolic names for modifier keys
SHIFT_CHAR=$'\u21e7'     # ⇧
CONTROL_CHAR=$'\u2303'   # ⌃  
OPTION_CHAR=$'\u2325'    # ⌥
COMMAND_CHAR=$'\u2318'   # ⌘
META_MODIFIER_CHARS="${CONTROL_CHAR}${OPTION_CHAR}${COMMAND_CHAR}"
MODIFIERS_KEYBOARD_NAVIGATION="${SHIFT_CHAR}${OPTION_CHAR}${COMMAND_CHAR}"

# Specify the local directory that is the “stow directory” that GNU Stow uses as
# both (a) the raw dotfiles representing various configurations and (b) the
# structural template defining where each symlink should reside in the user’s
# $HOME directory.
GMU_STOW_DIR="${GENOMAC_USER_LOCAL_DIRECTORY}/stow_directory"

# Specify the local directory into which the diff results of defaults_detective
# investigations will be saved.
GMU_LOCAL_DEFAULTS_DETECTIVE_RESULTS="$HOME/genomac-detective"

# Specify the local directory in which preferences and other files shared across users are stored
# These may contain secrets, so this directory is NOT within a repo
# E.g., this would be within each user’s Dropbox directory.
GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${LOCAL_DROPBOX_DIRECTORY}/Preferences_common"

# Specify the file name of the BetterTouchTool (BTT) preset to be auto-loaded at BTT startup
#
# TODO: Only GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH is actually used.
#       The other two are intermediate values that don’t need to be exported.
GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME="Default_preset.json"
GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY="$HOME/.config/BetterTouchTool"
GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH="${GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY}/${GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME}"

# Environment variables to support the Hypervisor
GMU_HYPERVISOR_MAKE_COMMAND_STRING="make run-hypervisor"
GMU_HYPERVISOR_HOW_TO_RESTART_STRING="To get back into the groove at any time, just re-execute ${GMU_HYPERVISOR_MAKE_COMMAND_STRING}${NEWLINE}and we’ll pick up where we left off."

# Environment variable specifies the packages for which dotfiles will be stowed.
GMU_ARRAY_OF_PACKAGES_TO_STOW_DOTFILES=("1password" "BetterTouchTool" "git" "homebrew" "ssh" "starship" "stow" "zsh")

# Export environment variables to be available in all subsequent shells
report_action_taken "Exporting environment variables specific to GenoMac-user."

export_and_report COMMAND_CHAR
export_and_report CONTROL_CHAR
export_and_report GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY
export_and_report GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME
export_and_report GENOMAC_USER_BTT_AUTOLOAD_PRESET_PATH
export_and_report GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY
export_and_report GMU_DOCS_TO_DISPLAY
export_and_report GMU_LOCAL_DEFAULTS_DETECTIVE_RESULTS
export_and_report GMU_STOW_DIR
export_and_report GMU_ARRAY_OF_PACKAGES_TO_STOW_DOTFILES
export_and_report GMU_HYPERVISOR_HOW_TO_RESTART_STRING
export_and_report GMU_HYPERVISOR_MAKE_COMMAND_STRING
export_and_report GMU_HYPERVISOR_SCRIPTS
export_and_report GMU_RESOURCES
export_and_report GMU_SCRIPTS
export_and_report GMU_SETTINGS_SCRIPTS
export_and_report GMU_UTILITIES
export_and_report HOMEBREW_PREFIX
export_and_report META_MODIFIER_CHARS
export_and_report MODIFIERS_KEYBOARD_NAVIGATION
export_and_report OPTION_CHAR
export_and_report PLISTBUDDY_PATH
export_and_report SHIFT_CHAR
