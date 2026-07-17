#!/usr/bin/env zsh

function set_menubar_settings() {
  # Set menubar settings
  report_start_phase_standard

  report_action_taken "Implement menubar-related settings"
  
  # Always show Sound in menubar
  report_adjust_setting "Always show Sound in menubar (not only when “active”)"
  defaults -currentHost write com.apple.controlcenter Sound -int 18 ; success_or_not
  
  # Give audible feedback when volume is changed
  report_adjust_setting "Give audible feedback when volume is changed"
  defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 1 ; success_or_not
  report_warning 'Nevertheless, the setting Sound » Play feedback… may need to be manually toggled afterward anyway.'
  
  # Show battery percentage in menubar
  report_adjust_setting "Show battery percentage in menubar"
  defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true ; success_or_not
  
  report_adjust_setting "Show time with seconds"
  defaults write com.apple.menuextra.clock ShowSeconds -bool true ; success_or_not
  
  # Show Fast User Switching in menubar as Account Name
  report_action_taken "Show Fast User Switching in menubar only as Account Name"
  report_adjust_setting "1 of 2: userMenuExtraStyle = 1 (Account Name)"
  defaults write NSGlobalDomain userMenuExtraStyle -int 1;success_or_not
  report_adjust_setting "2 of 2: UserSwitcher = 2 (menubar only)"
  defaults -currentHost write com.apple.controlcenter UserSwitcher -int 2 ; success_or_not

  # Show text-input menu in menubar
  report_adjust_setting "Show Input menu in menubar"
  defaults write com.apple.TextInputMenu visible -bool true ; success_or_not
  
  report_end_phase_standard
}
