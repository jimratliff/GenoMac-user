#!/usr/bin/env zsh

# Script to be executed only one time per user.

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
PREFS_FUNCTIONS_DIR="${this_script_dir}/prefs_scripts"

# Print assigned paths for diagnostic purposes
# printf "\n📂 Path diagnostics:\n"
# printf "this_script_dir:              %s\n" "$this_script_dir"
# printf "GENOMAC_HELPER_DIR: %s\n" "$GENOMAC_HELPER_DIR"
# printf "PREFS_FUNCTIONS_DIR:  %s\n\n" "$PREFS_FUNCTIONS_DIR"

safe_source "${PREFS_FUNCTIONS_DIR}/bootstrap_finder.sh" 
safe_source "${PREFS_FUNCTIONS_DIR}/bootstrap_preview_app.sh" 
############################## BEGIN SCRIPT PROPER #############################

# Finder: Define initial toolbar
bootstrap_finder

# Preview.app: Define initial toolbar
bootstrap_preview_app
