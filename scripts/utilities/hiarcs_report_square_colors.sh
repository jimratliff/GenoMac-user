#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

safe_source "${GMU_SETTINGS_SCRIPTS}/set_hiarcs_cd_pro_settings.sh"

function main() {
  hiarcs_chess_explorer_pro_utility_report_current_square_colors_for_defaults_write_commands
}

main
