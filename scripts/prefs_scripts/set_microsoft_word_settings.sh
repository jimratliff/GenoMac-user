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

# Construct path to macro-containing Word file
local source_path="${GENOMAC_USER_RESOURCE_DIRECTORY}/microsoft_word/${Word_document_filename}"

# Confirm existence of macro-containing Word file
if [[ ! -f "$source_path" ]]; then
  report_fail "Missing macro-containing Word document at ${source_path}"
  exit 1
fi

# Open the document in Word (this triggers Document_Open → SetMyPreferences)
open -a "Microsoft Word" "$source_path"

report_end_phase_standard

}
