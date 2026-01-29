#!/usr/bin/env zsh

# Intended to be sourced at the beginning of every entry-point script in ~/.genomac-user/
#
# TODO: Revisit, after 1/29/2026 refactoring, the below claims about what this script does.
#
# Performs:
# - Exports:
#   - GMU_SCRIPTS_DIR
#     - the path to ~/.genomac-user/scripts
#   - GMU_PREFS_SCRIPTS
#     - the path to ~/.genomac-user/scripts/prefs_scripts
#   - GMU_HELPERS_DIR
#     - the path to the helper scripts from the submodule GenoMac-shared
# - Sources:
#   - the helpers.sh script from GenoMac-shared, which in turn:
#     - sources all the other helpers-xxx.sh scripts from GenoMac-shared
#     - sources assign_common_environment_variables, which exports the environment variables 
#       that are common to both GenoMac-system and GenoMac-user
#   - assign_user_environment_variables.sh, which exports the environment variables that are 
#     specific to this repository
#
# It is assumed that the sourcing entry-point script is located at ~/.genomac-user/scripts
#
# Assumed directory structure
#   ~/.genomac-user/
#     external/
#       genomac-shared/
#         assign_common_environment_variables.sh
#         helpers-apps.h
#         …
#         helpers.sh
#     scripts/
#       0_initialize_me.sh        # You are HERE!
#       an_entry_point_script.sh  # The script of interest, will source 0_initialize_me.sh
#       prefs_scripts/

set -euo pipefail

echo "Inside /scripts/0_initialize_me_first.sh"

# Get path of THIS script, even when sourced
# Explanation:
# %x — zsh prompt escape meaning "path of the script being sourced"
# ${(%):-%x} — trick to evaluate a prompt escape outside a prompt (the (%) flag)
# ${...:A} — resolve to absolute path
# So ${${(%):-%x}:A} means "the absolute path of the file currently being sourced."
this_script_path="${${(%):-%x}:A}"              # ~/.genomac-user/scripts/0_initialize_me_first.sh

GENOMAC_USER_SCRIPTS="${this_script_path:h}"    # ~/.genomac-user/scripts
GENOMAC_USER_ROOT="${GENOMAC_USER_SCRIPTS:h}"   # ~/.genomac-user
GENOMAC_SHARED_ROOT_RELATIVE_TO_GENOMAC_USER="${GENOMAC_USER_ROOT}/external/genomac-shared" # ~/.genomac-user/external/genomac-shared

echo "Paths determined in 0_initialize_me_first.sh:"
echo "• this_script_path: ${this_script_path}"
echo "• GENOMAC_USER_SCRIPTS: ${GENOMAC_USER_SCRIPTS}"
echo "• GENOMAC_USER_ROOT: ${GENOMAC_USER_ROOT}"
echo "• GENOMAC_SHARED_ROOT_RELATIVE_TO_GENOMAC_USER: ${GENOMAC_SHARED_ROOT_RELATIVE_TO_GENOMAC_USER}"

# Source the master-helper script from GenoMac-shared submodule, which sources helpers
# and environment variables from GenoMac-shared
HELPERS_FROM_GENOMAC_SHARED="${GENOMAC_SHARED_ROOT_RELATIVE_TO_GENOMAC_USER}/scripts"  # external/genomac-shared/scripts
master_helper_script="${HELPERS_FROM_GENOMAC_SHARED}/helpers.sh"

echo "Source ${master_helper_script}"
source "${master_helper_script}"

# Source repo-specific environment-variables script
repo_specific_environment_variables="${GENOMAC_USER_SCRIPTS}/assign_user_environment_variables.sh"

echo "Source ${repo_specific_environment_variables}"
source "${repo_specific_environment_variables}"

echo "Leaving /scripts/0_initialize_me_first.sh"
