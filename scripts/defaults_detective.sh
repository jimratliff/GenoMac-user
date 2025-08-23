#!/usr/bin/env zsh

# Determines before-and-after changes to defaults domains as a result of
# change(s) to preferences.

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

DEFAULTS_DETECTIVE_FUNCTIONS_DIR="${this_script_dir}/defaults_detective"
source "${DEFAULTS_DETECTIVE_FUNCTIONS_DIR}/find_diff_from_setting_change.sh"

############################## BEGIN SCRIPT PROPER #############################
report_start_phase 'Begin determining changes to defaults due to change(s) in preferences'

find_diff_from_setting_change

report_end_phase 'Completed: determined changes to defaults due to change(s) in preferences'
