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
domain="com.apple.symbolichotkeys"
dict="AppleSymbolicHotKeys"

function rhs_xml_to_disable_specific_command() {
  # Echoes right-hand-side XML to disable a command:
  local TEMPLATE="<dict><key>enabled</key><false/></dict>"
  echo "$TEMPLATE"
}

function rhs_xml_to_enable_specific_command() {
  # Echoes right-hand-side XML to enable a command with hotkey specified by three arguments:
  #   $1: 
  #   $2: 
  #   $3:
  local TEMPLATE="
    <dict>
      <key>enabled</key><true/>
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>$1</integer>
          <integer>$2</integer>
          <integer>$3</integer>
        </array>
      </dict>
    </dict>
  "
  echo "$TEMPLATE"
}

function xml_to_set_symbolichotkeys() {

report_start_phase_standard
report_action_taken "Set hot-key correspondences to Apple commands"

report_fail "You need to finish writing this function!"

report_end_phase_standard

}
