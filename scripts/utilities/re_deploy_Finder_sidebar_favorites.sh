#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

safe_source "${GMU_SETTINGS_SCRIPTS}/set_finder_sidebar_favorites.sh"

function main() {
  set_user_finder_sidebar_favorites
}

main
