#!/bin/zsh

function set_trackpad_settings() {

  ########## Trackpad
  #
  #  Implements the following choices
  #  Point & Click
  #    Tracking speed: 7 (on a scale from 0 to 9)
  #    Click: Medium
  #    Quiet Click: No
  #    Force Click and haptic feedback: Yes
  #    Look up & data detectors: Force Click with One Finger
  #    Secondary click: Click or Tap with Two Fingers
  #    Tap to click: Yes
  #  Scroll & Zoom
  #    Natural scrolling: Yes
  #    Zoom in or out: Yes
  #    Smart zoom: Yes
  #    Rotate: Yes
  #  More Gestures
  #    Swipe between pages: Scroll Left or Right with Two Fingers
  #    Swipe between full-screen applications: No
  #    Notification Center: No
  #    Mission Control: Swipe Up with Four Fingers
  #    App Exposé: No
  #    Launchpad: No
  #    Show Desktop: Yes
  #  Accessibility » Pointer Control » Trackpad Options » 
  #    Use trackpad for dragging: Yes
  #    Dragging sytle: Three Finger Drag
  
  report_start_phase_standard
  report_action_taken "Implement configuration of Trackpad behavior"
  
  report_adjust_setting "Point & Click: Tracking speed"
  defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2 ; success_or_not
  
  report_action_taken "Point & Click: Click firmness"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: FirstClickThreshold"
  defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1 ; success_or_not
  report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: SecondClickThreshold"
  defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 1 ; success_or_not
  report_adjust_setting "Point & Click: Quiet Click"
  defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 1 ; success_or_not
  
  report_action_taken "Point & Click: Force Click"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: ActuateDetents"
  defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 1 ; success_or_not
  report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: ForceSuppressed"
  defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool false ; success_or_not
  report_adjust_setting "#3: c.a.AppleMultitouchTrackpad: TrackpadThreeFingerTapGesture"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0 ; success_or_not
  report_adjust_setting "#4: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadThreeFingerTapGesture"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0 ; success_or_not
  report_adjust_setting "#5: c.a.preference.trackpad: ForceClickSavedState"
  defaults write com.apple.preference.trackpad ForceClickSavedState -bool true ; success_or_not
  report_adjust_setting "#6: -cH -g: c.a.trackpad.threeFingerTapGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.threeFingerTapGesture -int 0 ; success_or_not
  
  report_adjust_setting "Point & Click: Lookup & data detectors"
  defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true ; success_or_not
  
  report_action_taken "Point & Click: Secondary click"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadRightClick"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true ; success_or_not
  report_adjust_setting "#2: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadRightClick"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true ; success_or_not
  report_adjust_setting "#3: -g: ContextMenuGesture"
  defaults write NSGlobalDomain ContextMenuGesture -int 1 ; success_or_not
  report_adjust_setting "#4: -cH -g: c.a.trackpad.enableSecondaryClick"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true ; success_or_not
  report_adjust_setting "#5: -cH -g: c.a.trackpad.trackpadCornerClickBehavior"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 0 ; success_or_not
  
  report_action_taken "Point & Click: Tap to click"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: Clicking"
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true ; success_or_not
  report_adjust_setting "#2: c.a.driver.AppleBluetoothMultitouch.trackpad: Clicking"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true ; success_or_not
  report_adjust_setting "#3: -cH -g: c.a.mouse.tapBehavior"
  defaults -currentHost write  NSGlobalDomain com.apple.mouse.tapBehavior -int 1 ; success_or_not
  
  report_adjust_setting "Scroll & Zoom: Natural scrolling"
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true ; success_or_not
  
  report_action_taken "Scroll & Zoom: Zoom in/out"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadPinch"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true ; success_or_not
  report_adjust_setting "#2: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadPinch"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true ; success_or_not
  report_adjust_setting "#3: -cH -g: c.a.trackpad.pinchGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.pinchGesture -bool true ; success_or_not
  
  report_action_taken "Scroll & Zoom: Smart Zoom"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadTwoFingerDoubleTapGesture"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1 ; success_or_not
  report_adjust_setting "#2: -cH -g: c.a.trackpad.twoFingerDoubleTapGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.twoFingerDoubleTapGesture -int 1 ; success_or_not
  
  report_action_taken "Scroll & Zoom: Rotate"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadRotate"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true ; success_or_not
  report_adjust_setting "#2: -cH -g: c.a.trackpad.rotateGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.rotateGesture -bool true ; success_or_not
  
  report_adjust_setting "More Gestures: Swipe between pages"
  defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true ; success_or_not
  
  report_action_taken "More Gestures: Swipe between full-screen apps"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadFourFingerHorizSwipeGesture"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 0 ; success_or_not
  report_adjust_setting "#2: -cH -g: c.a.trackpad.fourFingerHorizSwipeGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.fourFingerHorizSwipeGesture -int 0 ; success_or_not
  
  report_action_taken "More Gestures: Notification Center"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadTwoFingerFromRightEdgeSwipeGesture"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0 ; success_or_not
  report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: TrackpadTwoFingerFromRightEdgeSwipeGesture"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0 ; success_or_not
  report_adjust_setting "#3: -cH -g: c.a.trackpad.twoFingerFromRightEdgeSwipeGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture -int 0 ; success_or_not
  
  report_action_taken "More Gestures: Mission Control"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadFourFingerVertSwipeGesture"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2 ; success_or_not
  report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: TrackpadThreeFingerVertSwipeGesture"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0 ; success_or_not
  report_adjust_setting "#3: c.a.dock: showMissionControlGestureEnabled"
  defaults write com.apple.dock showMissionControlGestureEnabled -bool true ; success_or_not
  report_adjust_setting "#4: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadFourFingerVertSwipeGesture"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2 ; success_or_not
  report_adjust_setting "#5: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadThreeFingerVertSwipeGesture"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0 ; success_or_not
  report_adjust_setting "#6: -cH -g: c.a.trackpad.fourFingerVertSwipeGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.fourFingerVertSwipeGesture -int 2 ; success_or_not
  report_adjust_setting "#7: -cH -g: c.a.trackpad.threeFingerVertSwipeGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.threeFingerVertSwipeGesture -int 0 ; success_or_not
  
  report_adjust_setting "More Gestures: App Exposé"
  defaults write com.apple.dock showAppExposeGestureEnabled -bool false ; success_or_not
  
  report_adjust_setting "More Gestures: Launchpad"
  defaults write com.apple.dock showLaunchpadGestureEnabled -bool false ; success_or_not
  
  report_action_taken "More Gestures: Show Desktop"
  report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadFiveFingerPinchGesture"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2 ; success_or_not
  report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: TrackpadFourFingerPinchGesture"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2 ; success_or_not
  report_adjust_setting "#3: c.a.dock: showDesktopGestureEnabled"
  defaults write com.apple.dock showDesktopGestureEnabled -bool true ; success_or_not
  report_adjust_setting "#4: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadFiveFingerPinchGesture"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2 ; success_or_not
  report_adjust_setting "#5: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadFourFingerPinchGesture"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2 ; success_or_not
  report_adjust_setting "#6: -cH -g: c.a.trackpad.fiveFingerPinchSwipeGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.fiveFingerPinchSwipeGesture -int 2 ; success_or_not
  report_adjust_setting "#7: -cH -g: c.a.trackpad.fourFingerPinchSwipeGesture"
  defaults -currentHost write  NSGlobalDomain com.apple.trackpad.fourFingerPinchSwipeGesture -int 2 ; success_or_not
  
  report_action_taken "Accessibility » Pointer Control » Trackpad Options: Three-finger drag"
  report_adjust_setting "1 of 3: com.apple.AppleMultitouchTrackpad » TrackpadThreeFingerDrag"
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true ; success_or_not
  report_adjust_setting "2 of 3: com.apple.driver.AppleBluetoothMultitouch.trackpad » TrackpadThreeFingerDrag"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true ; success_or_not
  report_adjust_setting "3 of 3: -cH -g » com.apple.trackpad.threeFingerDragGesture"
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -bool true ; success_or_not
  
  report_end_phase_standard

}
