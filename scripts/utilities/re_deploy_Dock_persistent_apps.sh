#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_dock.sh"

function main() {
  bootstrap_dock_persistent_apps
}

main
