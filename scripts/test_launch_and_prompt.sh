#!/usr/bin/env zs

# Fail early on unset variables or command failure
set -euo pipefail

# Template for entry-point scripts

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

############################## BEGIN SCRIPT PROPER ##############################

# Source required files
# safe_source "${GMU_PREFS_SCRIPTS}/install_btt_license.sh"

function test_launch_app_and_prompt_user_to_act() {
  report_start_phase_standard

  launch_app_and_prompt_user_to_act "$BUNDLE_ID_TEXTEDIT" "Please do the thing"
  launch_app_and_prompt_user_to_act --show-doc "${GENOMAC_USER_DOCS_TO_DISPLAY_DIRECTORY}/TextExpander_how_to_configure.md" "$BUNDLE_ID_TEXTEDIT" "Please do the thing"
  
  report_end_phase_standard 

}

function main() {
  test_launch_app_and_prompt_user_to_act
}

main
