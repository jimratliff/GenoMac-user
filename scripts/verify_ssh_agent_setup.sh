#!/usr/bin/env zs

# Fail early on unset variables or command failure
set -euo pipefail

# Template for entry-point scripts

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

safe_source "${PREFS_FUNCTIONS_DIR}/verify_ssh_agent_configuration.sh"

function main() {
  verify_ssh_agent_configuration
}

main
