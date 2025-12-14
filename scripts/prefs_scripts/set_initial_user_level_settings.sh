# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

# This `source` cannot be `safe_source` because `safe_source` is in `helpers.sh`, which hasn’t yet been sourced.
source "${GENOMAC_HELPER_DIR}/helpers.sh"

safe_source "${PREFS_FUNCTIONS_DIR}/set_app_state_persistence.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_apps_to_launch_at_login.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_auto_correction_suggestion_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_bbedit_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_bettertouchtool_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_chatgpt_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_claude_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_default_apps_to_open.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_default_browser.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_default_shell.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_diskutility_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_finder_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_general_dock_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_general_interface_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_iterm_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_notifications_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_preview_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_safari_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_screen_capture_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_symbolichotkeys.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_terminal_settings.sh"
safe_source "${PREFS_FUNCTIONS_DIR}/set_trackpad_settings.sh"
# safe_source "${PREFS_FUNCTIONS_DIR}/set_warp_settings.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_initial_user_level_settings() {

report_start_phase_standard

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
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true ; success_or_not

report_adjust_setting "Enable Keyboard Navigation (with Tab key)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2 ; success_or_not

report_adjust_setting "Use F1, F2, etc. keys as standard function keys"
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true ; success_or_not

report_adjust_setting "Press and release globe (🌎) key to bring up emoji picker"
defaults write com.apple.HIToolbox AppleFnUsageType -int 2 ; success_or_not

# report_adjust_setting "Set symbolic hot keys to Apple commands"
set_symbolichotkeys ; success_or_not

############### Menubar 
report_action_taken "Implement menubar-related settings"

# Always show Sound in menubar
report_adjust_setting "Always show Sound in menubar (not only when “active”)"
defaults -currentHost write com.apple.controlcenter Sound -int 18;success_or_not

# Give audible feedback when volume is changed
report_adjust_setting "Give audible feedback when volume is changed"
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 1 ; success_or_not
report_warning $'Nevertheless, the setting Sound » Play feedback… may need to be manually toggled afterward anyway.'

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

# Language & Region
# Week starts on Monday
report_adjust_setting "Language & Region: Week starts on Monday"
defaults write -g AppleFirstWeekday -dict gregorian -int 2

# Notifications
set_notifications_settings

# Time Machine
report_adjust_setting "Time Machine: Don’t prompt to use new disk as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true ; success_or_not

# Set default browser
set_default_browser

# Set default apps to open for document types
set_default_apps_to_open

# Preview.app
set_preview_settings

# DiskUtility
set_diskutility_settings

# Terminal
set_terminal_settings

# Text Edit
report_adjust_setting "Text Edit: Make plain text the default format"
defaults write com.apple.TextEdit RichText -bool false;success_or_not

# Safari
set_safari_settings

############### THIRD-PARTY APPLICATIONS
report_action_taken "Begin settings for third-party applications"

# iTerm2
set_iterm_settings

# BBEdit
set_bbedit_settings

# BetterTouchTool
set_btt_settings

# ChatGPT
set_chatgpt_settings

# Claude
set_claude_settings

# Warp
# Warp is now excluded from Project GenoMac because it can’t be reliably configured via `defaults write`
# commands or by dotfiles. See Issue: https://github.com/warpdotdev/Warp/issues/7220
# set_warp_settings

############### Set apps to launch on login
set_apps_to_launch_at_login

report_end_phase_standard

}
