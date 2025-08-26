# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

source "${PREFS_FUNCTIONS_DIR}/set_app_state_persistence.sh"
source "${PREFS_FUNCTIONS_DIR}/set_auto_correction_suggestion_settings.sh"
source "${PREFS_FUNCTIONS_DIR}/set_default_shell.sh"
source "${PREFS_FUNCTIONS_DIR}/set_diskutility_settings.sh"
source "${PREFS_FUNCTIONS_DIR}/set_finder_settings.sh"
source "${PREFS_FUNCTIONS_DIR}/set_general_dock_settings.sh"
source "${PREFS_FUNCTIONS_DIR}/set_general_interface_settings.sh"
source "${PREFS_FUNCTIONS_DIR}/set_safari_settings.sh"
source "${PREFS_FUNCTIONS_DIR}/set_screen_capture_settings.sh"
source "${PREFS_FUNCTIONS_DIR}/set_terminal_settings.sh"
source "${PREFS_FUNCTIONS_DIR}/set_trackpad_settings.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_initial_user_level_settings() {

report_start_phase_standard

# Set user’s default shell to Homebrew’s version
set_default_shell

# Enable app-state persistence
set_app_state_persistence

# Trackpad
set_trackpad_settings

# Other general interface
set_general_interface_settings

# Stop intrusive/arrogant “corrections”
set_auto_correction_suggestion_settings

############### Keyboard-related defaults
report_action_taken "Implement keyboard-related defaults"

report_adjust_setting "Holding alpha key down pops up character-accent menu (rather than repeats). Reinforces default"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true;success_or_not

report_adjust_setting "Enable Keyboard Navigation (with Tab key)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2;success_or_not

report_adjust_setting "Use F1, F2, etc. keys as standard function keys"
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true;success_or_not

report_adjust_setting "Use globe (🌎) key as emoji picker"
defaults write com.apple.HIToolbox AppleFnUsageType -int 2;success_or_not

############### Menubar 
report_action_taken "Implement menubar-related settings"

# Always show Sound in menubar
report_adjust_setting "Always show Sound in menubar (not only when “active”)"
defaults -currentHost write com.apple.controlcenter sound -int 18;success_or_not

# Give audible feedback when volume is changed
report_adjust_setting "Give audible feedback when volume is changed"
defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool true;success_or_not

# Show battery percentage in menubar
report_adjust_setting "Show battery percentage in menubar"
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true;success_or_not

report_adjust_setting "Show time with seconds"
defaults write com.apple.menuextra.clock ShowSeconds -bool true;success_or_not

# Show Fast User Switching in menubar as Account Name
report_action_taken "Show Fast User Switching in menubar only as Account Name"
report_adjust_setting "1 of 2: userMenuExtraStyle = 1 (Account Name)"
defaults write NSGlobalDomain userMenuExtraStyle -int 1;success_or_not
report_adjust_setting "2 of 2: UserSwitcher = 2 (menubar only)"
defaults -currentHost write com.apple.controlcenter UserSwitcher -int 2;success_or_not

############### Control Center
# Add Bluetooth to Control Center to access battery percentages of Bluetooth devices
# This needs to be tested on laptop
report_adjust_setting "Add Bluetooth to Control Center to access battery percentages of Bluetooth devices"
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true;success_or_not

# Dock
set_general_dock_settings

# Screen Capture
set_screen_capture_settings

# Mission Control/Spaces
report_action_taken "Implement settings related to Spaces (Mission Control)"

report_adjust_setting "Spaces: Don’t rearrange based on most-recent use"
defaults write com.apple.dock mru-spaces -bool false;success_or_not

report_adjust_setting "Spaces span all display (no separate space for each monitor)"
defaults write com.apple.spaces "spans-displays" -bool "true";success_or_not

report_adjust_setting "Do not jump to a new space when switching applications"
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false;success_or_not

# Finder
set_finder_settings

# Time Machine
report_adjust_setting "Time Machine: Don’t prompt to use new disk as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true;success_or_not

# DiskUtility
set_diskutility_settings

# Terminal
set_terminal_settings

# Text Edit
report_adjust_setting "Text Edit: Make plain text the default format"
defaults write com.apple.TextEdit RichText -bool false;success_or_not

# Safari
set_safari_settings

report_end_phase_standard

}
