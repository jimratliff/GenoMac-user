# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_microsoft_word_settings() {

report_start_phase_standard

local domain="com.microsoft.Word"

report_action_taken "Set VERY limited Microsoft Word preferences with defaults write command(s)"

report_adjust_setting "Ribbon: Show group titles"
defaults write "${domain}" OUIRibbonShowGroupTitles -bool true ; success_or_not

report_action_taken "Use a VBA script to implement additional Microsoft Word preferences"

local Word_document_filename="Container_for_VBA_macro_to_set_Word_preferences.docm"

# NOTE: The below log-file path is *not* discretionary. It is hardwired into the VBA macro
# embedded in $Word_document_filename
local log_file_from_VBA_macro="/tmp/word_preferences_log.txt"

# Construct path to macro-containing Word file
local source_path="${GENOMAC_USER_RESOURCE_DIRECTORY}/microsoft_word/${Word_document_filename}"

# Confirm existence of macro-containing Word file
if [[ ! -f "$source_path" ]]; then
  report_fail "Missing macro-containing Word document at ${source_path}"
  exit 1
fi

# Remove any stale log file from a previous run
rm -f "$log_file_from_VBA_macro"

# Open the document in Word (this triggers Document_Open → SetMyPreferences)
open -a "Microsoft Word" "$source_path"

# Wait for the log file to appear (indicates macro completed)
local timeout=30
local elapsed=0
while [[ ! -f "$log_file_from_VBA_macro" && $elapsed -lt $timeout ]]; do
  sleep 1
  ((elapsed++))
done

# Brief additional wait to ensure file is fully written
sleep 1

# Report results
if [[ -f "$log_file_from_VBA_macro" ]]; then
  # Optionally echo the log contents or parse for status
  report "Here is a summary of actions taken by the VBA macro:"
  cat "$log_file_from_VBA_macro"
  success_or_not
else
  report_fail "Word preferences macro did not complete within ${timeout}s"
  exit 1
fi

report_end_phase_standard

}
