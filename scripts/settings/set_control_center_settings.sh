#!/usr/bin/env zsh

function set_control_center_settings() {
  # Set Control Center settings
  report_start_phase_standard

  # Add Bluetooth to Control Center to access battery percentages of Bluetooth devices
  # This needs to be tested on laptop
  report_adjust_setting "Add Bluetooth to Control Center to access battery percentages of Bluetooth devices"
  defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true ; success_or_not
  
  report_end_phase_standard
}
