#!/usr/bin/env zsh

# Script to be executed only one time per user.
# Launches certain applications to ensure that their .plist files exist in order
# to be modified by succeeding scripts.

# Fail early on unset variables or command failure
set -euo pipefail

# Resolve this script's directory (even if sourced)
this_script_path="${0:A}"
this_script_dir="${this_script_path:h}"

# Assign environment variables (including GENOMAC_HELPER_DIR).
# Assumes that assign_environment_variables.sh is in same directory as the
# current script.
source "${this_script_dir}/assign_environment_variables.sh"

# Source helpers
source "${GENOMAC_HELPER_DIR}/helpers.sh"

# Specify the directory in which the file(s) containing the preferences-related 
# functions called by this script lives.
# E.g., the function `overrides_for_sysadmin_users` is supplied by a file 
# `overrides_for_sysadmin_users.sh`. If `overrides_for_sysadmin_users.sh` 
# resides at the same level as this script:
# PREFS_FUNCTIONS_DIR="${this_script_dir}"
# PREFS_FUNCTIONS_DIR="${this_script_dir}/prefs_scripts"

# Print assigned paths for diagnostic purposes
printf "\n📂 Path diagnostics:\n"
printf "this_script_dir:              %s\n" "$this_script_dir"
printf "GENOMAC_HELPER_DIR: %s\n" "$GENOMAC_HELPER_DIR"
# printf "PREFS_FUNCTIONS_DIR:  %s\n\n" "$PREFS_FUNCTIONS_DIR"

# source "${PREFS_FUNCTIONS_DIR}/set_initial_user_level_settings.sh"
# source "${PREFS_FUNCTIONS_DIR}/overrides_for_sysadmin_users.sh"

############################## BEGIN SCRIPT PROPER #############################

launch_and_quit_app "com.apple.DiskUtility"
launch_and_quit_app "com.googlecode.iterm2"
# launch_and_quit_app "dev.warp.Warp-Stable"

# Launch and quit DiskUtility in order that it will have preferences to modify.
# report_action_taken "Launch and quit DiskUtility in order that it will have preferences to modify"
# open -b com.apple.DiskUtility # By bundle ID (more reliable than `open -a` by display name)
# sleep 2
# osascript -e 'quit app "Disk Utility"';success_or_not

# Launch and quit iTerm2 in order that it will have preferences to modify.
# report_action_taken "Launch and quit iTerm2 in order that it will have preferences to modify"
# open -b com.googlecode.iterm2 # By bundle ID (more reliable than `open -a` by display name)
# sleep 2
# osascript -e 'quit app "iTerm2"';success_or_not

# Launch and quit Warp in order that it will have preferences to modify.
# report_action_taken "Launch and quit Warp in order that it will have preferences to modify"
# open -b dev.warp.Warp-Stable # By bundle ID (more reliable than `open -a` by display name)
# sleep 2
# osascript -e 'quit app "Warp"';success_or_not
