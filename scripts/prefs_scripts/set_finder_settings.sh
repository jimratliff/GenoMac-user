#!/usr/bin/env zsh

function set_finder_settings() {

  report_start_phase_standard
  report_action_taken "Adjust settings for Finder"

  local finder_domain="com.apple.finder"
  local finder_plist="$HOME/Library/Preferences/com.apple.finder.plist"
  
  # Show all hidden files
  # Does NOT correspond to any UI command (except ⌘. which however does not change a default view).
  report_adjust_setting "Show all hidden files (i.e., “dot files”)"
  defaults write $finder_domain AppleShowAllFiles true ; success_or_not
  
  # Show Pathbar
  report_adjust_setting "Show path bar"
  defaults write $finder_domain ShowPathbar -bool true ; success_or_not
  
  # Show StatusBar
  report_adjust_setting "Show status bar"
  defaults write $finder_domain ShowStatusBar -bool true ; success_or_not
  
  # Show all filename extensions
  report_adjust_setting "Show all filename extensions"
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true ; success_or_not
  
  # Preferred window view: List view
  report_adjust_setting "Set Finder preferred window view to List View"
  defaults write $finder_domain FXPreferredViewStyle -string "Nlsv" ; success_or_not
  
  # Do not show hard drives on desktop
  # This is the intended system for regular user (other than the SysAdmin users USER_VANILLA and USER_CONFIGURER).
  # To set preferences for these SysAdmin users, a script should run following this scripts that inverts this boolean.
  report_adjust_setting "Do not show hard drives on desktop"
  defaults write $finder_domain ShowHardDrivesOnDesktop -bool false ; success_or_not
  
  # Do not show external drives on desktopdesktop
  # This is the intended system for regular user (other than the SysAdmin users USER_VANILLA and USER_CONFIGURER).
  # To set preferences for these SysAdmin users, a script should run following this scripts that inverts this boolean.
  report_adjust_setting "Do not show external drives on desktop"
  defaults write $finder_domain ShowExternalHardDrivesOnDesktop -bool false ; success_or_not
  
  # Show removable media (CDs, DVDs, etc.) on desktop
  # This is the default. Included here to enforce the default if it is ever changed.
  report_adjust_setting "Show removable media (CDs, DVDs, etc.) on desktop"
  defaults write $finder_domain ShowRemovableMediaOnDesktop -bool true ; success_or_not
  
  # Show connected servers on desktop
  report_adjust_setting "Show connected servers on desktop"
  defaults write $finder_domain ShowMountedServersOnDesktop -bool true ; success_or_not
  
  # Search from current folder by default (rather than from "This Mac")
  report_adjust_setting "Search from current folder by default (rather than from “This Mac”)"
  defaults write $finder_domain FXDefaultSearchScope -string "SCcf" ; success_or_not
  
  # Unhide the ~/Library folder
  report_adjust_setting "Unhide the ~/Library folder"
  chflags nohidden ~/Library ; success_or_not
  
  # Expand certain panels of GetInfo windows
  report_adjust_setting "Expand certain panels of GetInfo windows"
  defaults write $finder_domain FXInfoPanesExpanded -dict \
          General -bool true \
          MetaData -bool true \
          Name -bool true \
          Comments -bool true \
          OpenWith -bool true \
          Preview -bool true \
          Privileges -bool true ; success_or_not
  
  # Do not sort folders first (reinforces the default)
  report_action_taken "Do not sort folders first"
  report_adjust_setting "1 of 2: Do not sort folders first in lists"
  defaults write $finder_domain _FXSortFoldersFirst -bool false ; success_or_not
  report_adjust_setting "1 of 2: Do not sort folders first on desktop"
  defaults write $finder_domain "_FXSortFoldersFirstOnDesktop" -bool false ; success_or_not
  
  # Enable warning when changing extension (reinforces the default)
  report_adjust_setting "Enable warning when changing extension (reinforces the default)"
  defaults write $finder_domain FXEnableExtensionChangeWarning -bool true ; success_or_not
  
  # Folder opens in tab (not new window) after ⌘-double-click. (reinforces default)
  report_adjust_setting "⌘-double-click opens folder in new tab (not new window)"
  defaults write $finder_domain "FinderSpawnTab" -bool true ; success_or_not
  
  # Column view: Resize columns to fit filenames
  report_adjust_setting "Resize columns to fit filenames"
  defaults write $finder_domain "_FXEnableColumnAutoSizing" -bool true ; success_or_not
  
  # Set Icon Views to Snap to Grid
  report_action_taken "Setting Icon Views to Snap to Grid"
  # Computer View removed because it isn’t always present
  # report_adjust_setting "1 of 4: Computer Icon View"
  # ${PLISTBUDDY_PATH} -c "Set :ComputerViewSettings:IconViewSettings:arrangeBy grid" $finder_plist ; success_or_not
  report_adjust_setting "1 of 3: Desktop Icon View"
  ${PLISTBUDDY_PATH} -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" $finder_plist ; success_or_not
  report_adjust_setting "2 of 3: Standard Finder windows’ Icon View"
  ${PLISTBUDDY_PATH} -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" $finder_plist ; success_or_not
  report_adjust_setting "3 of 3: FK_Standard (Open dialog box) Icon View"
  ${PLISTBUDDY_PATH} -c "Set FK_StandardViewSettings:IconViewSettings:arrangeBy grid" $finder_plist ; success_or_not
  
  # Demand calculateAllSizes in all list views
  report_action_taken "Demand calculated sizes in all list views"
  report_adjust_setting "1 of 4: Standard, non-extended list view"
  ${PLISTBUDDY_PATH} -c "Set :'StandardViewSettings':'ListViewSettings':'calculateAllSizes' true" $finder_plist ; success_or_not
  report_adjust_setting "2 of 4: Standard, extended list view"
  ${PLISTBUDDY_PATH} -c "Set :'StandardViewSettings':'ExtendedListViewSettingsV2':'calculateAllSizes' true" $finder_plist ; success_or_not
  report_adjust_setting "3 of 4: FK (dialog box), non-extended list view"
  ${PLISTBUDDY_PATH} -c "Set :'FK_StandardViewSettings':'ListViewSettings':'calculateAllSizes' true" $finder_plist ; success_or_not
  report_adjust_setting "4 of 4: FK (dialog box), extended list view"
  ${PLISTBUDDY_PATH} -c "Set :'FK_StandardViewSettings':'ExtendedListViewSettingsV2':'calculateAllSizes' true" $finder_plist ; success_or_not
  
  report_end_phase_standard

}

function reverse_disk_display_policy_for_some_users() {
  # Reverses the standard default, when requested: do show internal/external drives on Desktop

  report_start_phase_standard
  report_action_taken "Reverse certain disk-display-on-Desktop defaults for certain users"
  
  local finder_domain="com.apple.finder"

  # DO show hard drives on desktop
  # This reverses the default used in set_finder_settings()
  report_adjust_setting "DO show hard drives on desktop (reversing, at your request, an earlier action)"
  defaults write $finder_domain ShowHardDrivesOnDesktop -bool true ; success_or_not
  
  # Do not show external drives on desktopdesktop
  # This reverses the default used in set_finder_settings()
  report_adjust_setting "DO show external drives on desktop (reversing, at your request, an earlier action)"
  defaults write $finder_domain ShowExternalHardDrivesOnDesktop -bool true ; success_or_not

  report_about_to_kill_app "Finder"
  killall "Finder" ; success_or_not

  report_end_phase_standard
}
