#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

safe_source "${GMU_INSTALLATION_SCRIPTS}/install_bookmarks_into_browsers.sh"

function main() {
  install_bookmarks_into_browsers
}

main
