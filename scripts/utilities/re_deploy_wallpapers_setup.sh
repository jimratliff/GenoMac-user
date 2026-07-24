#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

# safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_set_permissions.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_wallpapers.sh"

function main() {
  set_wallpapers_for_all_spaces
}

main
