#!/usr/bin/env zsh

function set_keyboard_related_defaults() {
  # Set keyboard-related defaults
  report_start_phase_standard

  report_action_taken "Implement keyboard-related defaults"
  
  report_adjust_setting "Holding alpha key down pops up character-accent menu (rather than repeats). Reinforces default"
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true ; success_or_not
  
  report_adjust_setting "Enable Keyboard Navigation (with Tab key)"
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 2 ; success_or_not
  
  report_adjust_setting "Use F1, F2, etc. keys as standard function keys"
  defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true ; success_or_not
  
  report_adjust_setting "Press and release globe (🌎) key to bring up emoji picker"
  defaults write com.apple.HIToolbox AppleFnUsageType -int 2 ; success_or_not
  
  report_end_phase_standard
}
