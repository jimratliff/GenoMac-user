#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

safe_source "${GMU_SETTINGS_SCRIPTS}/set_spacejump_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_wallpapers.sh"

function main() {
  set_wallpapers_for_all_spaces
  specify_Space_names_in_SpaceJump
}

main
