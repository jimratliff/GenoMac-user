# Prevent multiple sourcing
if [[ -n "${__already_loaded_symbolichotkeys_helpers_sh:-}" ]]; then return 0; fi
__already_loaded_symbolichotkeys_helpers_sh=1

# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############### HELPERS

plistbud="/usr/libexec/PlistBuddy"
domain="com.apple.symbolichotkeys"
symdict="AppleSymbolicHotKeys"


get_ascii_code_for_char() {
  # Function to get ASCII code of character in only argument.
  # Returns 65535 if character has no ASCII code (i.e., > 127)
  # Example usage:
  #   get_ascii_code "A"     # Returns: 65
  #   get_ascii_code "z"     # Returns: 122
  #   get_ascii_code "0"     # Returns: 48
  #   get_ascii_code "€"     # Returns: 65535 (not ASCII)
  #   get_ascii_code ""      # Returns: 65535 (empty string)
    local char="$1"
    local NO_VALID_ASCII=65535
    
    # Check if argument is provided
    if [[ -z "$char" ]]; then
        report_fail "Error: no argument supplied to get_ascii_code()."
        return 1
    fi
    
    # Get the first character only
    char="${char:0:1}"
    
    # Get the Unicode code point using printf
    local code_point
    code_point=$(printf '%d' "'$char")
    
    # ASCII is 0-127, return 65535 for anything outside this range
    if [[ $code_point -le 127 ]]; then
        echo "$code_point"
    else
        echo "$NO_VALID_ASCII"
    fi
}



function modify_symbolichotkeys_entry_for_command_by_id() {
  # Modifies the dictionary entry corresponding to a particular command specified by its ID.
  #  $1: The integer ID of the command whose dictionary entry is to be modified
  #      E.g., the integer ID of the command kCGSHotKeyInvertScreen (Reverse Black and White) is 21.
  #  $2: The XML value for the new dictionary entry

  local command_ID=$1
  local xml_value=$2
  defaults write "$domain" "$symdict" -dict-add $command_ID "${xml_value}"
}

function disable_command_its_id() {
  # Disables command identified by its ID, which is specified by the single supplied argument.
  # Example usage:
  # To disable the command kCGSHotKeyInvertScreen (Reverse Black and White), which has the command ID 21:
  #   disable_command_its_id 21
  # Assumes $domain and $symdict have been defined in a location available to this function.
  
  local XML_TO_DISABLE_COMMAND="<dict><key>enabled</key><false/></dict>"
  command_ID=$1
  modify_symbolichotkeys_entry_for_command_by_id $command_ID "${XML_TO_DISABLE_COMMAND}"
}

function xml_value_for_hot_key_by_ascii_code_key_code_modifier_mask() {
  # Echoes right-hand-side XML value to enable a hotkey specified by three arguments:
  #   $1: ASCII_code of the key
  #       If the key has no ASCII code (e.g., one of the Fkeys), use 65535
  #   $2: KEY_CODE
  #       The “AppleScript key code” for the key as found in “Complete list of AppleScript key codes,”
  #       https://eastmanreference.com/complete-list-of-applescript-key-codes
  #   $3: MODIFIER_MASK
  local xml_value="
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
  echo "$xml_value"
}
