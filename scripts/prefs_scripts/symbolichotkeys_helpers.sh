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

# Assumes the following environment variables are defined in, and sourced from, assign_environment_variables.sh
# SHIFT_CHAR=$'\u21e7'     # ⇧
# CONTROL_CHAR=$'\u2303'   # ⌃  
# OPTION_CHAR=$'\u2325'    # ⌥
# COMMAND_CHAR=$'\u2318'   # ⌘
# META_MODIFIER_CHARS="${CONTROL_CHAR}${OPTION_CHAR}${COMMAND_CHAR}"

domain="com.apple.symbolichotkeys"
symdict="AppleSymbolicHotKeys"

function disable_command_by_its_id() {
  # Disables command identified by its ID, which is specified by the single supplied argument.
  # Example usage:
  # To disable the command kCGSHotKeyInvertScreen (Reverse Black and White), which has the command ID 21:
  #   disable_command_its_id 21
  
  local XML_TO_DISABLE_COMMAND="<dict><key>enabled</key><false/></dict>"
  command_ID=$1
  modify_symbolichotkeys_entry_for_command_by_id $command_ID "${XML_TO_DISABLE_COMMAND}"
}

function assign_hotkey_to_command_id() {
  # Assigns a hotkey (combination of key and a set of modifiers) to a particular command.
  # Takes three arguments:
  # - $1: Command ID (integer), e.g., 8 [corresponds to Move focus to the Dock (kCGSHotKeyFocusDock)]
  # - $2: Key name (case insensitive), e.g., "F3", "a", "E", "up-arrow", etc.
  # - $3: Modifier characters, e.g., ${CONTROL_CHAR}
  #

  local command_ID="$1"
  local key_name="$2"
  local modifier_chars="$3"

  local ascii_and_virtual_key_codes=$(get_hotkey_ascii_and_AppleScript_key_codes "$key_name")

  local modifier_combo_mask=$(modifier_combination_to_mask "$modifier_chars" )

  # Note that $ascii_and_virtual_key_codes is a *pair* of space separated strings, and is thus used to supply *two* arguments.
  xml_value = xml_value_for_hot_key_by_ascii_code_key_code_and_modifier_mask "$ascii_and_virtual_key_codes" "$modifier_combo_mask"

  modify_symbolichotkeys_entry_for_command_by_id "$command_ID" "$xml_value"
  

}

function modify_symbolichotkeys_entry_for_command_by_id() {
  # Modifies the dictionary entry corresponding to a particular command specified by its ID.
  #  $1: The integer ID of the command whose dictionary entry is to be modified
  #      E.g., the integer ID of the command kCGSHotKeyInvertScreen (Reverse Black and White) is 21.
  #  $2: The XML value for the new dictionary entry
  #
  # Assumes $domain and $symdict have been defined in a location available to this function.

  local command_ID=$1
  local xml_value=$2
  defaults write "$domain" "$symdict" -dict-add $command_ID "${xml_value}"
}

function xml_value_for_hot_key_by_ascii_code_key_code_and_modifier_mask() {
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

function modifier_combination_to_mask() {
  # Takes a single string containing only concatenated modifier-key characters and returns the
  # corresponding integer mask for that combination of modifiers.
  #
  # Accepted modifier-key characters (defined in a scope that can be accessed from this function):
  # 	SHIFT_CHAR='⇧'
  #		CONTROL_CHAR='⌃'
  # 	OPTION_CHAR='⌥'
  # 	COMMAND_CHAR='⌘'
  #
  # There is no prescribed order of occurrence when there is more than one modifier key.
  # A duplicate occurrence of any particular modifier-key character is ignored.
  #
  # Example usage:
  #   modifier_combination_to_mask "⌥⌘"     # Returns: 1572864 (Option + Command)
  #   modifier_combination_to_mask "⇧⌃"     # Returns: 393216 (Shift + Control)
  #   modifier_combination_to_mask "⌘"      # Returns: 1048576 (Command only)
  #   modifier_combination_to_mask ""       # Returns: 0 (no modifiers)
  #   modifier_combination_to_mask "${OPTION_CHAR}${COMMAND_CHAR}"   # Returns: 1572864 (Option + Command)
  #   modifier_combination_to_mask "${SHIFT_CHAR}${CONTROL_CHAR}"    # Returns: 393216 (Shift + Control)
  #   modifier_combination_to_mask "${COMMAND_CHAR}"      		     # Returns: 1048576 (Command only)
  #
  # The mask for each of the modifier keys is documented at “How to map F14, F15, and F16 to Exposé, Dashboard, etc.,”
  #   Mac OS X Hints, April 11, 2005, 
  #   https://web.archive.org/web/20141113040759/http://hints.macworld.com/article.php?story=20050801052917667
  
  # Define mask values (powers of 2)
  local SHIFT_CHAR_MASK=$((2**17))      # 131072
  local CONTROL_CHAR_MASK=$((2**18))    # 262144
  local OPTION_CHAR_MASK=$((2**19))     # 524288
  local COMMAND_CHAR_MASK=$((2**20))    # 1048576

  # valid_chars must be updated if the set of valid modifier keys is expanded or shrunk
  local valid_chars="${SHIFT_CHAR}${CONTROL_CHAR}${OPTION_CHAR}${COMMAND_CHAR}"

  local modifiers="$1"

 # Check if argument is provided
  if [[ -z "$modifiers" ]]; then
    report_fail "Error: modifier_combination_to_mask() requires a modifier(s) string argument"
    return 1
  fi
  
  # Validate that string contains only valid modifier characters by removing all valid characters and see if anything remains
  local temp_modifiers="$modifiers"
  temp_modifiers="${temp_modifiers//[$valid_chars]/}"
  if [[ -n "$temp_modifiers" ]]; then
    report_fail "Error: Invalid characters in modifier string: '$temp_modifiers'"
    return 1
  fi
  
  # Initialize contribution variables (duplicates become benign)
  local shift_contribution=0
  local control_contribution=0
  local option_contribution=0
  local command_contribution=0
  
  # Set contributions based on presence of each modifier character
  if [[ "$modifiers" == *"$SHIFT_CHAR"* ]]; then
    shift_contribution=$SHIFT_CHAR_MASK
  fi
  
  if [[ "$modifiers" == *"$CONTROL_CHAR"* ]]; then
    control_contribution=$CONTROL_CHAR_MASK
  fi
  
  if [[ "$modifiers" == *"$OPTION_CHAR"* ]]; then
    option_contribution=$OPTION_CHAR_MASK
  fi
  
  if [[ "$modifiers" == *"$COMMAND_CHAR"* ]]; then
    command_contribution=$COMMAND_CHAR_MASK
  fi
  
  # Calculate final mask
  local mask=$((shift_contribution + control_contribution + option_contribution + command_contribution))
  
  echo "$mask"
}

function get_hotkey_ascii_and_AppleScript_key_codes() {
  # Function to map a case-insensitive key description (e.g., 'g', 'F3', or 'down-arrow') to a (ASCII code, AppleScript key code) pair.
  # Returns: "ascii_code applescript_code" or "ERROR" if key not found
  # Example usage:
  #   get_hotkey_ascii_and_AppleScript_key_codes "a"        # Returns: "97 0"
  #   get_hotkey_ascii_and_AppleScript_key_codes "F5"       # Returns: "65535 96"
  #   get_hotkey_ascii_and_AppleScript_key_codes "space"    # Returns: "32 49"
  #   get_hotkey_ascii_and_AppleScript_key_codes "up-arrow" # Returns: "65535 126"
  #
  # Sources for virtual keycodes:
  # - Complete list of AppleScript key codes, Eastman Reference, https://eastmanreference.com/complete-list-of-applescript-key-codes
  # - HIToolbox/Events.h, lines 184 et seq.
  #   https://github.com/phracker/MacOSX-SDKs/blob/master/MacOSX10.6.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h
  # - Code values for keyboard events » Code values on Mac, Mozilla Developer Network (MDN)
  #   https://developer.mozilla.org/en-US/docs/Web/API/UI_Events/Keyboard_event_code_values#code_values_on_mac
  
  local key="$1"
    
	# Check if argument is provided
	if [[ -z "$key" ]]; then
    report_fail "Error: get_hotkey_ascii_and_AppleScript_key_codes() requires a key-description argument"
    return 1
	fi
	
	# Convert to lowercase for easier matching
	local key_lower="${key:l}"
	
	# Define associative arrays for the mappings
	local -A ascii_codes applescript_codes
	
	# Letters (lowercase and uppercase map to same AppleScript codes)
 	# ASCII code		 Virtual keycode number		Virtual keycode name
	ascii_codes[a]=97;   applescript_codes[a]=0		# kVK_ANSI_A
	ascii_codes[b]=98;   applescript_codes[b]=11	# kVK_ANSI_B
	ascii_codes[c]=99;   applescript_codes[c]=8		# kVK_ANSI_C
	ascii_codes[d]=100;  applescript_codes[d]=2		# kVK_ANSI_D
	ascii_codes[e]=101;  applescript_codes[e]=14	# kVK_ANSI_E
	ascii_codes[f]=102;  applescript_codes[f]=3		# kVK_ANSI_F
	ascii_codes[g]=103;  applescript_codes[g]=5		# kVK_ANSI_G
	ascii_codes[h]=104;  applescript_codes[h]=4		# kVK_ANSI_H
	ascii_codes[i]=105;  applescript_codes[i]=34	# kVK_ANSI_I
	ascii_codes[j]=106;  applescript_codes[j]=38	# kVK_ANSI_J
	ascii_codes[k]=107;  applescript_codes[k]=40	# kVK_ANSI_K
	ascii_codes[l]=108;  applescript_codes[l]=37	# kVK_ANSI_L
	ascii_codes[m]=109;  applescript_codes[m]=46	# kVK_ANSI_M
	ascii_codes[n]=110;  applescript_codes[n]=45	# kVK_ANSI_N
	ascii_codes[o]=111;  applescript_codes[o]=31	# kVK_ANSI_O
	ascii_codes[p]=112;  applescript_codes[p]=35	# kVK_ANSI_P
	ascii_codes[q]=113;  applescript_codes[q]=12	# kVK_ANSI_Q
	ascii_codes[r]=114;  applescript_codes[r]=15	# kVK_ANSI_R
	ascii_codes[s]=115;  applescript_codes[s]=1		# kVK_ANSI_S
	ascii_codes[t]=116;  applescript_codes[t]=17	# kVK_ANSI_T
	ascii_codes[u]=117;  applescript_codes[u]=32	# kVK_ANSI_U
	ascii_codes[v]=118;  applescript_codes[v]=9		# kVK_ANSI_V
	ascii_codes[w]=119;  applescript_codes[w]=13	# kVK_ANSI_W
	ascii_codes[x]=120;  applescript_codes[x]=7		# kVK_ANSI_X
	ascii_codes[y]=121;  applescript_codes[y]=16	# kVK_ANSI_Y
	ascii_codes[z]=122;  applescript_codes[z]=6		# kVK_ANSI_Z
	
	# Numbers
 	# ASCII code		 Virtual keycode number 	Virtual keycode name
	ascii_codes[0]=48;   applescript_codes[0]=29	# kVK_ANSI_0
	ascii_codes[1]=49;   applescript_codes[1]=18	# kVK_ANSI_1
	ascii_codes[2]=50;   applescript_codes[2]=19	# kVK_ANSI_2
	ascii_codes[3]=51;   applescript_codes[3]=20	# kVK_ANSI_3
	ascii_codes[4]=52;   applescript_codes[4]=21	# kVK_ANSI_4
	ascii_codes[5]=53;   applescript_codes[5]=23	# kVK_ANSI_5
	ascii_codes[6]=54;   applescript_codes[6]=22	# kVK_ANSI_6
	ascii_codes[7]=55;   applescript_codes[7]=26	# kVK_ANSI_7
	ascii_codes[8]=56;   applescript_codes[8]=28	# kVK_ANSI_8
	ascii_codes[9]=57;   applescript_codes[9]=25	# kVK_ANSI_9
	
	# Special characters (using their ASCII values)
 	# ASCII code		  Virtual keycode number 	Virtual keycode name
	ascii_codes['~']=126; applescript_codes['~']=50 # kVK_ANSI_Grave
	ascii_codes['!']=33;  applescript_codes['!']=18 # kVK_ANSI_1
	ascii_codes['@']=64;  applescript_codes['@']=19 # kVK_ANSI_2
	ascii_codes['#']=35;  applescript_codes['#']=20 # kVK_ANSI_3
	ascii_codes['$']=36;  applescript_codes['$']=21 # kVK_ANSI_4
	ascii_codes['%']=37;  applescript_codes['%']=23 # kVK_ANSI_5
	ascii_codes['^']=94;  applescript_codes['^']=22 # kVK_ANSI_6
	ascii_codes['&']=38;  applescript_codes['&']=26 # kVK_ANSI_7
	ascii_codes['*']=42;  applescript_codes['*']=28 # kVK_ANSI_8
	ascii_codes['(']=40;  applescript_codes['(']=25 # kVK_ANSI_9
	ascii_codes[')']=41;  applescript_codes[')']=29 # kVK_ANSI_0
	ascii_codes['-']=45;  applescript_codes['-']=27	# kVK_ANSI_Minus
	ascii_codes['+']=43;  applescript_codes['+']=24	# kVK_ANSI_Equal
	ascii_codes['=']=61;  applescript_codes['=']=24	# kVK_ANSI_Equal
	ascii_codes['[']=91;  applescript_codes['[']=33 # kVK_ANSI_LeftBracket
	ascii_codes[']']=93;  applescript_codes[']']=30 # kVK_ANSI_RightBracket
	ascii_codes['\']=92;  applescript_codes['\']=42	# kVK_ANSI_Backslash
	ascii_codes[';']=59;  applescript_codes[';']=41	# kVK_ANSI_Semicolon
	ascii_codes["'"]=39;  applescript_codes["'"]=39	# kVK_ANSI_Quote
	ascii_codes[',']=44;  applescript_codes[',']=43	# kVK_ANSI_Comma
	ascii_codes['.']=46;  applescript_codes['.']=47	# kVK_ANSI_Period
	ascii_codes['/']=47;  applescript_codes['/']=44	# kVK_ANSI_Slash
	ascii_codes['`']=96;  applescript_codes['`']=50	# kVK_ANSI_Grave
	
	# Function keys (no ASCII equivalent)
 	# ASCII code		 	 Virtual keycode number 	Virtual keycode name
	ascii_codes[f1]=65535;   applescript_codes[f1]=122	# kVK_F1
	ascii_codes[f2]=65535;   applescript_codes[f2]=120	# kVK_F2
	ascii_codes[f3]=65535;   applescript_codes[f3]=99	# kVK_F3
	ascii_codes[f4]=65535;   applescript_codes[f4]=118	# kVK_F4
	ascii_codes[f5]=65535;   applescript_codes[f5]=96	# kVK_F5
	ascii_codes[f6]=65535;   applescript_codes[f6]=97	# kVK_F6
	ascii_codes[f7]=65535;   applescript_codes[f7]=98	# kVK_F7
	ascii_codes[f8]=65535;   applescript_codes[f8]=100	# kVK_F8
	ascii_codes[f9]=65535;   applescript_codes[f9]=101	# kVK_F9
	ascii_codes[f10]=65535;  applescript_codes[f10]=109	# kVK_F10
	ascii_codes[f11]=65535;  applescript_codes[f11]=103	# kVK_F11
	ascii_codes[f12]=65535;  applescript_codes[f12]=111	# kVK_F12
	
	# Special keys
 	# ASCII code		 	  Virtual keycode number 		Virtual keycode name
	ascii_codes[space]=32;    applescript_codes[space]=49	# kVK_Space
	ascii_codes[tab]=9;       applescript_codes[tab]=48		# kVK_Tab
	ascii_codes[return]=13;   applescript_codes[return]=36	# kVK_Return
	ascii_codes[delete]=127;  applescript_codes[delete]=51	# kVK_Delete
	ascii_codes[escape]=27;   applescript_codes[escape]=53	# kVK_Escape
	
	# Arrow keys (no ASCII equivalent)
 	# ASCII code		    		Virtual keycode number 				Virtual keycode name
	ascii_codes[up-arrow]=65535;    applescript_codes[up-arrow]=126		# kVK_UpArrow
	ascii_codes[down-arrow]=65535;  applescript_codes[down-arrow]=125	# kVK_DownArrow
	ascii_codes[left-arrow]=65535;  applescript_codes[left-arrow]=123	# kVK_LeftArrow
	ascii_codes[right-arrow]=65535; applescript_codes[right-arrow]=124  # kVK_RightArrow
	
	# Modifier keys (no ASCII equivalent)
 	# ASCII code		 		  Virtual keycode number 		  Virtual keycode name
	ascii_codes[shift]=65535;     applescript_codes[shift]=56	  # kVK_Shift
	ascii_codes[control]=65535;   applescript_codes[control]=59   # kVK_Control
	ascii_codes[option]=65535;    applescript_codes[option]=58	  # kVK_Option
	ascii_codes[command]=65535;   applescript_codes[command]=55	  # kVK_Command
	ascii_codes[fn]=65535;        applescript_codes[fn]=63		  # kVK_Function
	ascii_codes[capslock]=65535;  applescript_codes[capslock]=57  # kVK_CapsLock
	
	# Check if key exists in our mapping
	if [[ -n ${ascii_codes[$key_lower]} ]]; then
	  echo "${ascii_codes[$key_lower]} ${applescript_codes[$key_lower]}"
	else
		report_fail "Error: Unknown key description '$key'"
		return 1
	fi
}

function get_command_description() {
	# Function to get description of a command for a given command ID
	# Usage: get_command_description <ID>
	# Returns: Description string for the given ID, or error message if ID not found
	#
	# Example usage:
	# 	get_command_description 120  # Returns: "Switch to Desktop 3"
	# 	get_command_description 32   # Returns: "Mission Control (was: Expose: All Windows) (kCGSHotKeyExposeAllWindows)"
	# 	get_command_description 999  # Returns error message
	
	local command_id="$1"
	
	# Check if argument is provided
	if [[ -z "$command_id" ]]; then
		report_fail "Error: get_command_description requires a command ID argument"
		return 1
	fi
	
	# Declare associative array for command ID to description mapping
	local -A command_descriptions
	
	# Populate the associative array with ID -> Description mappings
	command_descriptions[7]="Move focus to the menu bar (kCGSHotKeyFocusMenubar)"
	command_descriptions[8]="Move focus to the Dock (kCGSHotKeyFocusDock)"
	command_descriptions[9]="Move focus to active or next window (kCGSHotKeyFocusNextGlobalWindow)"
	command_descriptions[10]="Move focus to window toolbar (kCGSHotKeyFocusToolbar)"
	command_descriptions[11]="Move focus to floating window (kCGSHotKeyFocusFloatingWindow)"
	command_descriptions[12]="Turn keyboard access on or off (kCGSHotKeyToggleFullKeyboardAccess)"
	command_descriptions[13]="Change the way Tab moves focus (kCGSHotKeyFocusNextControl)"
	command_descriptions[15]="Turn zoom on or off (kCGSHotKeyToggleZoom)"
	command_descriptions[17]="Zoom in (kCGSHotKeyZoomIn)"
	command_descriptions[19]="Zoom out (kCGSHotKeyZoomOut)"
	command_descriptions[21]="Reverse Black and White (kCGSHotKeyInvertScreen)"
	command_descriptions[23]="Turn image smoothing on or off (kCGSHotKeyZoomToggleSmoothing)"
	command_descriptions[25]="Increase contrast (kCGSHotKeyIncreaseContrast)"
	command_descriptions[26]="Decrease contrast (kCGSHotKeyDecreaseContrast)"
	command_descriptions[27]="Move focus to the next window in applications (kCGSHotKeyFocusApplicationWindow)"
	command_descriptions[28]="Save picture of screen as file (kCGSHotKeyScreenshot)"
	command_descriptions[29]="Copy picture of screen to clipboard (kCGSHotKeyScreenshotToClipboard)"
	command_descriptions[30]="Save picture of selected area as file (kCGSHotKeyScreenshotRegion)"
	command_descriptions[31]="Copy picture of selected area to clipboard (kCGSHotKeyScreenshotRegionToClipboard)"
	command_descriptions[32]="Mission Control (was: Expose: All Windows) (kCGSHotKeyExposeAllWindows)"
	command_descriptions[33]="Expose: Application Windows (kCGSHotKeyExposeApplicationWindows)"
	command_descriptions[34]="All Windows (slow) (kCGSHotKeyExposeAllWindowsSlow)"
	command_descriptions[35]="Application Windows (slow) (kCGSHotKeyExposeApplicationWindowsSlow)"
	command_descriptions[36]="Desktop (kCGSHotKeyExposeDesktop)"
	command_descriptions[37]="Desktop (slow) (kCGSHotKeyExposeDesktopsSlow)"
	command_descriptions[50]="Toggle Character Pallette (kCGSHotKeyToggleCharacterPallette)"
	command_descriptions[51]="Move focus to the window drawer (kCGSHotKeyFocusDrawer)"
	command_descriptions[52]="Turn Dock Hiding On/Off  (kCGSHotKeyToggleDockAutohide)"
	command_descriptions[53]="Decrease Display Brightness (kCGSHotKeyDecreaseDisplayBrightness)"
	command_descriptions[54]="Increase Display Brightness (kCGSHotKeyIncreaseDisplayBrightness)"
	command_descriptions[57]="Move focus to the status menus (kCGSHotKeyFocusStatusItems)"
	command_descriptions[59]="Turn VoiceOver on / off (kCGSHotKeyToggleVoiceOver)"
	command_descriptions[60]="Select the previous input source (kCGSHotKeySelectPreviousInputSource)"
	command_descriptions[61]="Select the next source in the Input Menu (kCGSHotKeySelectNextInputSource)"
	command_descriptions[62]="Dashboard (kCGSHotKeyDashboard)"
	command_descriptions[63]="Dashboard (slow) (kCGSHotKeyDashboardSlow)"
	command_descriptions[64]="Show Spotlight search field (kCGSHotKeySpotlightSearchField)"
	command_descriptions[65]="Show Spotlight window (kCGSHotKeySpotlightWindow)"
	command_descriptions[70]="Dictionary MouseOver (kCGSHotKeyLookUpWordInDictionary)"
	command_descriptions[73]="Hide and show Front Row (kCGSHotKeyToggleFrontRow)"
	command_descriptions[75]="Activate Spaces (kCGSHotKeySpaces)"
	command_descriptions[76]="Activate Spaces (slow) (kCGSHotKeySpacesSlow)"
	command_descriptions[79]="Move left a space (kCGSHotKeySpaceLeft)"
	command_descriptions[80]="Move left a space (Slow?) (kCGSHotKeySpaceLeftSlow)"
	command_descriptions[81]="Move right a space (kCGSHotKeySpaceRight)"
	command_descriptions[82]="Move right a space (slow) (kCGSHotKeySpaceRightSlow)"
	command_descriptions[83]="Spaces Down (kCGSHotKeySpaceDown)"
	command_descriptions[84]="Spaces Down (slow) (kCGSHotKeySpaceDownSlow)"
	command_descriptions[85]="Spaces Up (kCGSHotKeySpaceUp)"
	command_descriptions[86]="Space Up (slow) (kCGSHotKeySpaceUpSlow)"
	command_descriptions[98]="Show Help Menu (kCGSHotKeyHelp)"
	command_descriptions[118]="Switch to Desktop 1"
	command_descriptions[119]="Switch to Desktop 2"
	command_descriptions[120]="Switch to Desktop 3"
	command_descriptions[121]="Switch to Desktop 4"
	command_descriptions[122]="Switch to Desktop 5"
	command_descriptions[123]="Switch to Desktop 6"
	command_descriptions[124]="Switch to Desktop 7"
	command_descriptions[125]="Switch to Desktop 8"
	command_descriptions[126]="Switch to Desktop 9"
	command_descriptions[127]="Switch to Desktop 10"
	command_descriptions[128]="Switch to Desktop 11"
	command_descriptions[129]="Switch to Desktop 12"
	command_descriptions[130]="Switch to Desktop 13"
	command_descriptions[131]="Switch to Desktop 14"
	command_descriptions[132]="Switch to Desktop 15"
	command_descriptions[133]="Switch to Desktop 16"
	
	# Look up the description for the given ID
	if [[ -n "${command_descriptions[$command_id]}" ]]; then
		echo "${command_descriptions[$command_id]}"
	else
		report_fail "Error: Unknown command ID '$command_id'"
		return 1
	fi
}

function get_ascii_code_for_key() {
  # Helper function to get just the ASCII code for a key description
  local result=$(get_key_codes "$1")
  if [[ $? -eq 0 ]]; then
    echo "${result%% *}"
  else
    report_fail "Error: Unknown key description '$1'"
    return 1
  fi
}

function get_applescript_code() {
  # Helper function to get just the AppleScript key code
  local result=$(get_key_codes "$1")
  if [[ $? -eq 0 ]]; then
    echo "${result##* }"
  else
    report_fail "Error: Unknown key description '$1'"
    return 1
  fi
}

function get_ascii_code_for_char() {
  # Function to get ASCII code of character in only argument.
  #
  # WARNING: Perhaps not in use
  #
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
