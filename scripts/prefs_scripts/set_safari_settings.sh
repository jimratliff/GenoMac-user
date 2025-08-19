# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_safari_settings() {

report_start_phase_standard
report_action_taken "Implement Safari settings"

report_adjust_setting "Do NOT auto-open “safe” downloads"
sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false;success_or_not

report_adjust_setting "Never automatically open a website in a tab rather than a window"
sudo defaults write com.apple.Safari TabCreationPolicy -int 0;success_or_not

report_adjust_setting "Show full website address in Smart Search field"
sudo defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true;success_or_not

report_action_taken "Implement “Press Tab to highlight each item on a webpage”"
report_adjust_setting "1 of 2: WebKitPreferences.tabFocusesLinks"
defaults write com.apple.Safari WebKitPreferences.tabFocusesLinks -bool true;success_or_not
report_adjust_setting "2 of 2: WebKitTabToLinksPreferenceKey"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true;success_or_not

report_adjust_setting "Show status bar"
defaults write com.apple.Safari ShowOverlayStatusBar -bool true;success_or_not

# report_adjust_setting "Show favorites bar (NOT WORKING)"
# WARNING: This is not working reliably
# defaults write com.apple.Safari "ShowFavoritesBar-v2" -bool true;success_or_not
# defaults write com.apple.Safari "ShowFavoritesBar" -bool true;success_or_not

report_adjust_setting "⌘-click opens a link in a new tab (reinforces default)"
defaults write com.apple.Safari CommandClickMakesTabs -bool true;success_or_not

report_adjust_setting "Do NOT make a new tab/window active"
defaults write com.apple.Safari OpenNewTabsInFront -bool false;success_or_not

report_adjust_setting "Always show website titles in tabs"
defaults write com.apple.Safari EnableNarrowTabs -bool false;success_or_not

report_action_taken "Turn on: Prevent cross-site tracking (reinforces default)"
report_adjust_setting "1 of 3: BlockStoragePolicy"
defaults write com.apple.Safari BlockStoragePolicy -int 2;success_or_not
report_adjust_setting "2 of 3: WebKitPreferences.storageBlockingPolicy"
defaults write com.apple.Safari WebKitPreferences.storageBlockingPolicy -int 1;success_or_not
report_adjust_setting "3 of 3: WebKitStorageBlockingPolicy"
defaults write com.apple.Safari WebKitStorageBlockingPolicy -int 1;success_or_not

report_action_taken "Warn if visit a fraudulent site"
report_adjust_setting "1 of 2: WarnAboutFraudulentWebsites"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true;success_or_not
report_adjust_setting "2 of 2: com.apple.Safari.SafeBrowsing » SafeBrowsingEnabled"
defaults write com.apple.Safari.SafeBrowsing SafeBrowsingEnabled -bool true;success_or_not

report_action_taken "Show features for web developers"
report_adjust_setting "1 of 5: IncludeDevelopMenu"
defaults write com.apple.Safari IncludeDevelopMenu -bool true;success_or_not
report_adjust_setting "2 of 5: MobileDeviceRemoteXPCEnabled"
defaults write com.apple.Safari MobileDeviceRemoteXPCEnabled -bool true;success_or_not
report_adjust_setting "3 of 5: WebKitDeveloperExtrasEnabledPreferenceKey"
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true;success_or_not
report_adjust_setting "4 of 5: WebKitPreferences.developerExtrasEnabled"
defaults write com.apple.Safari WebKitPreferences.developerExtrasEnabled -bool true;success_or_not
report_adjust_setting "5 of 5: Safari.SandboxBroker: IncludeDevelopMenu"
defaults write com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true;success_or_not

report_adjust_setting "Reveal internal debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true;success_or_not

report_end_phase_standard

}
