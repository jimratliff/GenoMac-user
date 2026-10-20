#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_dock.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/process_user_attributes.sh"

function main() {
  conditionally_process_user_attribute_states
  bootstrap_dock_persistent_apps
  delete_all_user_SESH_states
}

main
