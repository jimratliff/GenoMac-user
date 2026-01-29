#!/usr/bin/env zsh

# Fail early on unset variables or command failure
set -euo pipefail

# Template for entry-point scripts

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Source required files
safe_source "${GMU_SETTINGS_SCRIPTS}/interactive_configure_keyboard_maestro.sh"

function prep_keyboard_maestro_for_experiments() {
  report_start_phase_standard

  set_keyboard_maestro_settings
  enable_keyboard_maestro_macro_syncing

  report_end_phase_standard

}

function main() {
  prep_keyboard_maestro_for_experiments
}

main
