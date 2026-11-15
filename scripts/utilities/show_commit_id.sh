#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

function main() {

  local commit_id
  commit_id="${ get_commit_id )"
  report "Current commit ID is: ${commit_id"
}


main
