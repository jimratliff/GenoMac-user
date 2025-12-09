# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_default_apps_to_open() {
# Sets default app(s) for certain document type(s)
#
# Uses Uniform Type Identifiers (UTIs) to refer to document types.
# Uses bundle IDs to refer to apps
#
# To determine the UTI of…
#   a particular file:
#   mdls -name kMDItemContentType -r /path/to/file
#
#   an extension (using an example file):
#   mdls -name kMDItemContentType -r example.md
#
# To determine the bundle ID of an app:
#   mdls -name kMDItemCFBundleIdentifier -r /Applications/AppName.app
#     or
#   osascript -e 'id of app "App Name"'

report_start_phase_standard
report_action_taken "Assign default app(s) for document type(s)"

local uti_plain_text=public.plain-text
local uti_markdown=net.daringfireball.markdown
local uti_shell_script=public.shell-script

local bundle_id_text_edit_app="com.apple.TextEdit"
local bundle_id_bbedit_app="com.barebones.bbedit"
local bundle_id_Plain_Text_Editor_app="com.sindresorhus.Plain-Text-Editor"

report_adjust_setting "Set plain-text files to open with BBEdit"
utiluti type set $uti_plain_text    $bundle_id_bbedit_app ; success_or_not

report_adjust_setting "Set Markdown files to open with BBEdit"
utiluti type set $uti_markdown       $bundle_id_bbedit_app ; success_or_not

report_adjust_setting "Set shell scripts to open with BBEdit"
utiluti type set $uti_shell_script   $bundle_id_bbedit_app ; success_or_not

report_end_phase_standard

}
