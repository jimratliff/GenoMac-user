#!/usr/bin/env zsh

# Implements an initial set of selected `defaults` and related commands for each 
# user. Specifically, the settings covered by this script pertain only to the
# the operating system and to applications that come pre-installed on a new
# out-of-the-box Mac.

# Fail early on unset variables or command failure
set -euo pipefail

# Resolve this script's directory (even if sourced)
this_script_path="${0:A}"
this_script_dir="${this_script_path:h}"

# Assign environment variables (including GENOMAC_HELPER_DIR).
# Assumes that assign_environment_variables.sh is in same directory as the
# current script.
source "${this_script_dir}/assign_environment_variables.sh"

# Assign environment variables that correspond to states
# Assumes that assign_enum_env_vars_for_states.sh is in same directory as the
# current script.
source "${this_script_dir}/assign_enum_env_vars_for_states.sh"

# Source helpers
source "${GENOMAC_HELPER_DIR}/helpers.sh"

# Specify the directory in which the file(s) containing the preferences-related 
# functions called by this script lives.
# E.g., the function `overrides_for_sysadmin_users` is supplied by a file 
# `overrides_for_sysadmin_users.sh`. If `overrides_for_sysadmin_users.sh` 
# resides at the same level as this script:
# PREFS_FUNCTIONS_DIR="${this_script_dir}"
PREFS_FUNCTIONS_DIR="${this_script_dir}/prefs_scripts"

# Print assigned paths for diagnostic purposes
printf "\n📂 Path diagnostics:\n"
printf "this_script_dir:              %s\n" "$this_script_dir"
printf "GENOMAC_HELPER_DIR: %s\n" "$GENOMAC_HELPER_DIR"
printf "PREFS_FUNCTIONS_DIR:  %s\n\n" "$PREFS_FUNCTIONS_DIR"

safe_source "${PREFS_FUNCTIONS_DIR}/set_initial_user_level_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/overrides_for_sysadmin_users.sh"

############################## BEGIN SCRIPT PROPER #############################
report_start_phase 'Begin the initial preference-setting phase'

# com.apple.universalaccess and com.apple.safari domains now require sudo
report_action_taken "Some commands will require 'sudo'"
keep_sudo_alive

# Set initial user-level settings
set_initial_user_level_settings

# Override certain settings in a way appropriate for only SysAdmin accounts
# TO DO: TODO: This needs to be made conditional on which user it is.
# overrides_for_sysadmin_users

report_end_phase 'Completed: the preference-setting phase of the bootstrapping process.' 
report "It’s possible that some settings won’t take effect until after you logout or restart."

dump_accumulated_warnings_failures

report "Logging out to apply those changes..."
echo ""
echo "ℹ️  You will be logged out automatically to take into account the changed settings."
echo "   After logging back in, continue with the next configuration step."
echo ""

force_user_logout

