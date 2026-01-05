#!/bin/zsh

function set_general_dock_settings() {

  report_start_phase_standard
  report_action_taken "Implement general Dock settings (but not populating the Dock with apps)"
  
  local domain="com.apple.dock"
  
  report_adjust_setting "Dock: Turn OFF automatic hide/show the Dock"
  defaults write "${domain}" autohide -bool false ; success_or_not
  
  report_adjust_setting "Dock: Turn on magnification effect when hovering over Dock"
  defaults write "${domain}" magnification -bool true ; success_or_not
  
  report_adjust_setting "Dock: Set size of magnified Dock icons"
  defaults write "${domain}" largesize -float 128 ; success_or_not
  
  report_adjust_setting "Dock: Show indicator lights for open apps"
  defaults write "${domain}" show-process-indicators -bool true ; success_or_not
  
  report_adjust_setting "Make Dock icons of hidden apps translucent"
  defaults write "${domain}" showhidden -bool true ; success_or_not
  
  report_adjust_setting "Dock: Enable two-finger scrolling on Dock icon to reveal thumbnails of all windows for that app"
  defaults write "${domain}" scroll-to-open -bool true ; success_or_not
  
  report_adjust_setting "Minimize to Dock rather than to app’s Dock icon"
  defaults write "${domain}" minimize-to-application -bool false ; success_or_not
  
  # This is NOT working as of 7/2/2025
  # report_adjust_setting "Highlight the element of a grid-view Dock stack over which the cursor hovers"
  # defaults write "${domain}" mouse-over-hilte-stack -bool true ; success_or_not
  
  # Hot-corner settings
  report_adjust_setting "Set bottom-right corner to Start Screen Saver"
  defaults write "${domain}" wvous-br-modifier -int 0
  defaults write "${domain}" wvous-br-corner -int 5 ; success_or_not
  
  report_adjust_setting "Set bottom-left corner to Disable Screen Saver"
  defaults write "${domain}" wvous-bl-modifier -int 0
  defaults write "${domain}" wvous-bl-corner -int 6 ; success_or_not
  
  report_end_phase_standard

}
