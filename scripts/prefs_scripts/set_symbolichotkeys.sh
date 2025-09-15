# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

plistbud="/usr/libexec/PlistBuddy"

function set_symbolichotkeys() {

report_start_phase_standard
report_action_taken "Set hot-key correspondences to Apple commands"

report_fail "You need to finish writing this function!"

report_end_phase_standard

}
