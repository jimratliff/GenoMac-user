#!/usr/bin/env zsh

function set_app_state_persistence() {

  # Specifies policies for app-state persistence, i.e., whether a window or app reopens after restart
  # I _do_ want windows/apps to reopen. I believe this is the default and that the below reinforces defaults.

  report_start_phase_standard
  report_action_taken "Implement app-state persistence"
  
  report_adjust_setting "1 of 3: loginwindow: TALLogoutSavesState: true"
  defaults write com.apple.loginwindow TALLogoutSavesState -bool true ; success_or_not
  report_adjust_setting "2 of 3: loginwindow: LoginwindowLaunchesRelaunchApps: true"
  defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool true ; success_or_not
  report_adjust_setting "3 of 3: NSGlobalDomain: NSQuitAlwaysKeepsWindows: true"
  defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true ; success_or_not
  
  # Closing a document window confirms any dirty changes
  report_adjust_setting "Implement document-state persistence"
  defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true ; success_or_not
  
  report_end_phase_standard

}
