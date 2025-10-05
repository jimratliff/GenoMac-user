# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function install_btt_license_file() {
# To be run only once per user to install the BetterTouchTool license file.

report_start_phase_standard
report_action_taken "Bootstrap-only installation of BetterTouchTool license file."

local license_file_origin_subpath="BetterTouchTool/LICENSE/bettertouchtool.bttlicense"

local license_file_origin="${GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY}/${license_file_origin_subpath}"

local license_file_destination_directory="$HOME/Library/Application Support/BetterTouchTool"

report_action_taken "Verify that source license file exists"
if [[ ! -f "$license_file_origin" ]]; then
  report_fail "Source license file not found at: $license_file_origin"
  report_end_phase_standard
  return 1
fi
report_success "Source license file verified: $license_file_origin"

report_action_taken "Ensure destination folder exists: $license_file_destination_directory"
mkdir -p "$license_file_destination_directory" ; success_or_not

report_end_phase_standard
}
