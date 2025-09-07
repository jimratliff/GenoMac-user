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
finder_plist="$HOME/Library/Preferences/com.apple.finder.plist"

function set_finder_settings() {

report_start_phase_standard
report_action_taken "Adjust settings for Finder"

# Open new windows to HOME
# This is intended for bootstrapping ONLY, not for enforcement
report_adjust_setting "By default, new Finder window should open to user’s home directory"
defaults write com.apple.finder NewWindowTarget -string "PfHm";success_or_not

# Show all hidden files
# Does NOT correspond to any UI command (except ⌘. which however does not change a default view).
report_adjust_setting "Show all hidden files (i.e., “dot files”)"
defaults write com.apple.finder AppleShowAllFiles true;success_or_not

# Show Pathbar
report_adjust_setting "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true;success_or_not

# Show StatusBar
report_adjust_setting "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true;success_or_not

# Show all filename extensions
report_adjust_setting "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;success_or_not

# Preferred window view: List view
report_adjust_setting "Set Finder preferred window view to List View"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv";success_or_not

# Do not show hard drives on desktop
# This is the intended system for regular user (other than the SysAdmin users USER_VANILLA and USER_CONFIGURER).
# To set preferences for these SysAdmin users, a script should run following this scripts that inverts this boolean.
report_adjust_setting "Do not show hard drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false;success_or_not

# Do not show external drives on desktopdesktop
# This is the intended system for regular user (other than the SysAdmin users USER_VANILLA and USER_CONFIGURER).
# To set preferences for these SysAdmin users, a script should run following this scripts that inverts this boolean.
report_adjust_setting "Do not show external drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false;success_or_not

# Show removable media (CDs, DVDs, etc.) on desktop
# This is the default. Included here to enforce the default if it is ever changed.
report_adjust_setting "Show removable media (CDs, DVDs, etc.) on desktop"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true;success_or_not

# Show connected servers on desktop
report_adjust_setting "Show connected servers on desktop"
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true;success_or_not

# Search from current folder by default (rather than from "This Mac")
report_adjust_setting "Search from current folder by default (rather than from “This Mac”)"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf";success_or_not

# Unhide the ~/Library folder
report_adjust_setting "Unhide the ~/Library folder"
chflags nohidden ~/Library;success_or_not

# Expand certain panels of GetInfo windows
report_adjust_setting "Expand certain panels of GetInfo windows"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
        General -bool true \
        MetaData -bool true \
        Name -bool true \
        Comments -bool true \
        OpenWith -bool true \
        Preview -bool true \
        Privileges -bool true;success_or_not

# Do not sort folders first (reinforces the default)
report_action_taken "Do not sort folders first"
report_adjust_setting "1 of 2: Do not sort folders first in lists"
defaults write com.apple.finder _FXSortFoldersFirst -bool false;success_or_not
report_adjust_setting "1 of 2: Do not sort folders first on desktop"
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool false;success_or_not

# Enable warning when changing extension (reinforces the default)
report_adjust_setting "Enable warning when changing extension (reinforces the default)"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true;success_or_not

# Folder opens in tab (not new window) after ⌘-double-click. (reinforces default)
report_adjust_setting "⌘-double-click opens folder in new tab (not new window)"
defaults write com.apple.finder "FinderSpawnTab" -bool true;success_or_not

# Set Icon Views to Snap to Grid
report_action_taken "Setting Icon Views to Snap to Grid"

report_adjust_setting "1 of 3: Desktop Icon View"
$plistbud -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" $finder_plist ; success_or_not

report_adjust_setting "2 of 3: Standard Finder windows’ Icon View"
$plistbud -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" $finder_plist ; success_or_not

report_adjust_setting "3 of 3: FK_Standard (Open dialog box) Icon View"
$plistbud -c "Set FK_StandardViewSettings:IconViewSettings:arrangeBy grid" $finder_plist ; success_or_not

# Demand calculateAllSizes in all list views
report_action_taken "Demand calculated sizes in all list views"

report_adjust_setting "1 of 4: Standard, non-extended list view"
$plistbud -c "Set :'StandardViewSettings':'ListViewSettings':'calculateAllSizes' true" $finder_plist ; success_or_not
report_adjust_setting "2 of 4: Standard, extended list view"
$plistbud -c "Set :'StandardViewSettings':'ExtendedListViewSettingsV2':'calculateAllSizes' true" $finder_plist ; success_or_not
report_adjust_setting "3 of 4: FK (dialog box), non-extended list view"
$plistbud -c "Set :'FK_StandardViewSettings':'ListViewSettings':'calculateAllSizes' true" $finder_plist ; success_or_not
report_adjust_setting "4 of 4: FK (dialog box), extended list view"
$plistbud -c "Set :'FK_StandardViewSettings':'ExtendedListViewSettingsV2':'calculateAllSizes' true" $finder_plist ; success_or_not


report_end_phase_standard

}
