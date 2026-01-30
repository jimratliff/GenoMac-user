#!/usr/bin/env zsh

# Initializes any entry-point script by sourcing:
# - helpers and cross-repo environment variables from GenoMac-shared
# - environment variables specific to the GenoMac-user repository
#
# WARNING: There are hard-wired paths in this script. Some/all of these paths are
#          referred to in other scripts (typically referenced by exported 
#          environment variables). Because this is a bootstrap script, the paths
#          are hard-wired rather than referring to those environment variables.

# Fail early on unset variables or command failure
set -euo pipefail

echo "Inside /scripts/0_initialize_me_first.sh"

# Get path of THIS script, even when sourced
# Explanation:
#   %x — zsh prompt escape meaning "path of the script being sourced"
#   ${(%):-%x} — trick to evaluate a prompt escape outside a prompt (the (%) flag)
#   ${...:A} — resolve to absolute path
#   So ${${(%):-%x}:A} means "the absolute path of the file currently being sourced."
this_script_path="${${(%):-%x}:A}"              # ~/.genomac-user/scripts/0_initialize_me_first.sh

# NOTE: The following are NOT exported. They are defined/calculated here only for the purpose
#       of sourcing other scripts from this script.
GENOMAC_USER_SCRIPTS="${this_script_path:h}"    # ~/.genomac-user/scripts
GENOMAC_USER_ROOT="${GENOMAC_USER_SCRIPTS:h}"   # ~/.genomac-user
GENOMAC_SHARED_ROOT_RELATIVE_TO_GENOMAC_USER="${GENOMAC_USER_ROOT}/external/genomac-shared" # ~/.genomac-user/external/genomac-shared
HELPERS_FROM_GENOMAC_SHARED="${GENOMAC_SHARED_ROOT_RELATIVE_TO_GENOMAC_USER}/scripts"  # external/genomac-shared/scripts

echo "Paths determined in 0_initialize_me_first.sh:"
echo "• this_script_path: ${this_script_path}"
echo "• GENOMAC_USER_SCRIPTS: ${GENOMAC_USER_SCRIPTS}"
echo "• GENOMAC_USER_ROOT: ${GENOMAC_USER_ROOT}"
echo "• GENOMAC_SHARED_ROOT_RELATIVE_TO_GENOMAC_USER: ${GENOMAC_SHARED_ROOT_RELATIVE_TO_GENOMAC_USER}"

# Source the master-helper script from GenoMac-shared submodule, which sources helpers
# and environment variables from GenoMac-shared
master_helper_script="${HELPERS_FROM_GENOMAC_SHARED}/helpers.sh"

echo "Source ${master_helper_script}"
source "${master_helper_script}"

# Source repo-specific environment-variables script
repo_specific_environment_variables="${GENOMAC_USER_SCRIPTS}/assign_user_environment_variables.sh"

echo "Source ${repo_specific_environment_variables}"
source "${repo_specific_environment_variables}"

echo "Leaving /scripts/0_initialize_me_first.sh"
