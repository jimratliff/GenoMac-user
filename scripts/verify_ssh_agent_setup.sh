#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

# Template for entry-point scripts

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

safe_source "${GMU_PREFS_SCRIPTS}/interactive_configure_1password.sh"

function main() {
  verify_ssh_agent_configuration
}

main
