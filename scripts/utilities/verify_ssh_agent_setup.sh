#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_1password.sh"

function main() {
  verify_ssh_agent_configuration
}

main
