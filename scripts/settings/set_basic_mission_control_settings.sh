#!/usr/bin/env zsh

function set_basic_mission_control_settings() {
  # Set basic Mission Control settings
  report_start_phase_standard

  report_action_taken "Implement settings related to Spaces (Mission Control)"
  
  report_adjust_setting "Spaces: Don’t rearrange based on most-recent use"
  defaults write com.apple.dock mru-spaces -bool false ; success_or_not
  
  report_adjust_setting "Spaces span all displays (no separate space for each monitor)"
  defaults write com.apple.spaces "spans-displays" -bool "true" ; success_or_not
  
  report_adjust_setting "Do not jump to a new space when switching applications"
  defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false ; success_or_not
  
  report_adjust_setting "Do not enter Mission Control when dragging window to top of screen"
  defaults write com.apple.dock enterMissionControlByTopWindowDrag -bool false ; success_or_not
  
  report_end_phase_standard
}
