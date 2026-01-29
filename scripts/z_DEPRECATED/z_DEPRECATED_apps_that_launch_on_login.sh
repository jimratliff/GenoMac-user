#!/bin/zsh

# Installs BetterTouchTool (BTT) license file.
# The source of the license file is assumed to me:
# GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY/BetterTouchTool/LICENSE/bettertouchtool.bttlicense

# Fail early on unset variables or command failure
set -euo pipefail

# Resolve this script's directory (even if sourced)
this_script_path="${0:A}"
this_script_dir="${this_script_path:h}"

# Assign environment variables (including GENOMAC_HELPER_DIR).
# Assumes that assign_environment_variables.sh is in same directory as this script.
source "${this_script_dir}/assign_environment_variables.sh"

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

# Source function(s)
safe_source "${PREFS_FUNCTIONS_DIR}/set_apps_to_launch_at_login.sh"

############################## BEGIN SCRIPT PROPER ##############################
function apps_that_launch_on_login() {
  report_start_phase_standard

  # Set apps that launch on login
  set_apps_to_launch_at_login

  report_end_phase_standard

}

function main() {
  apps_that_launch_on_login
}

main
