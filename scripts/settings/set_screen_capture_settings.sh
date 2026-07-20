#!/usr/bin/env zsh

function set_screen_capture_settings() {

  report_start_phase_standard
  report_action_taken "Implement settings related to Screen Capture"

  # For barebones settings, Screenshots is created at root of user’s home directory
  # This will be later overruled for users who want their Screenshot directory within their Dropbox.
  local path_for_screen_capture_result="$HOME/Screenshots"
  local permissions_for_screenshot_directory="700"
  set_screen_capture_destination "$path_for_screen_capture_result" "$permissions_for_screenshot_directory"
  
  report_adjust_setting "Screenshot: Specify that target is a file"
  # Needed only when overriding an assignment to clipboard or an app (e.g., Mail, Preview)
  defaults write com.apple.screencapture target -string "file" ; success_or_not
  
  report_adjust_setting "Screenshot: Show floating thumbnail (reinforces default)"
  defaults write com.apple.screencapture show-thumbnail -bool true ; success_or_not
  
  report_adjust_setting "Screenshot: Disable the drop shadow on screenshots"
  defaults write com.apple.screencapture disable-shadow -bool "true" ; success_or_not
  
  report_end_phase_standard

}

function set_screen_capture_destination_for_Dropbox_user() {

############### TODO WIP

  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard
  report_end_phase_standard
}

function set_screen_capture_destination() {
  # Sets path to screenshot folder, creating it if necessary, and enforce permissions.
  #
  # Conventional permissions:
  # - When at root of home directory: 700
  # - When in Dropbox: 755
  
  report_start_phase_standard
  local screen_capture_destination_path="${1:?MISSING screen-capture destination path}"
  local permissions="${2:?MISSING numeric permissions}"

  report_adjust_setting "Screenshot: Setting destination to: ${screen_capture_destination_path}"

  report_to_log "Create screen-capture destination directory, if necessary, at $screen_capture_destination_path"
  mkdir -p "$screen_capture_destination_path"

  report_to_log "Set permissions (${permissions}) on screen-capture destination directory"
  chmod "$permissions" "$screen_capture_destination_path"

  report_to_log "Assign path to screen-capture directory"
  defaults write com.apple.screencapture location -string "$screen_capture_destination_path"

  # Store destination into `location-last`, so Screenshot app can populate the “Other Location…” when using ⌘5.
  # It’s a history/convenience value so the system can offer quick access to other recently used locations.
  report_to_log "Write path to location-last."
  defaults write com.apple.screencapture location-last -string "$screen_capture_destination_path"

  success_or_not
  report_end_phase_standard
}
