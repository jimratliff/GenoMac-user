#!/usr/bin/env zs

# Intended to be sourced at the beginning of every entry-point script in ~/.genomac-user/
#
# Performs:
# - Sources:
#   - the helpers.sh script from GenoMac-shared, which in turn:
#     - sources all the other helpers-xxx.sh scripts from GenoMac-shared
#     - exports the environment variables that are common to both GenoMac-system and GenoMac-user
#   - the environment variables that are specific to this repository
#
# It is assumed that the sourcing entry-point script is located at ~/.genomac-user/scripts
#
# Assumed directory structure
#   ~/.genomac-user/
#     external/
#       genomac-shared/
#         assign_coomon_environment_variables.sh
#         helpers-apps.h
#         …
#         helpers.sh
#     scripts/
#       0_initialize_me.sh        # You are HERE!
#       an_entry_point_script.sh  # The script of interest, will source 0_initialize_me.sh
#       prefs_scripts/

set -euo pipefail

# Resolve directory of the current script
this_script_path="${0:A}"

GMU_SCRIPTS_DIR="${this_script_path:h}"
GMU_PREFS_SCRIPTS="${GMU_SCRIPTS_DIR}/prefs_scripts"
GMU_HELPERS_DIR="${GMU_SCRIPTS_DIR:h}/external/genomac-shared"

master_common_helpers_script="${GMU_HELPERS_DIR}/helpers.sh"
repo_specific_environment_variables_script="${GMU_SCRIPTS_DIR}/assign_user_environment_variables.sh"

function export_and_report() {
  local var_name="$1"
  report "export $var_name: '${(P)var_name}'"
  export "$var_name"
}

export_and_report GMU_SCRIPTS_DIR
export_and_report GMU_PREFS_SCRIPTS
export_and_report GMU_HELPERS_DIR

function safe_source() {
  # Ensures that an error is raised if a `source` of the file in the supplied argument fails.
  # Usage:
  #  safe_source "${PREFS_FUNCTIONS_DIR}/set_safari_settings.sh"
  local file="$1"
  if ! source "$file"; then
    echo "ERROR: Failed to source $file"
    exit 1
  fi
}

safe_source "${master_common_helpers_script}"
safe_source "${repo_specific_environment_variables_script}"
