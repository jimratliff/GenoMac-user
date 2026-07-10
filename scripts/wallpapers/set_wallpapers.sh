#!/usr/bin/env zsh

function conditionally_set_wallpapers_for_all_spaces() {
  # Set wallpapers for all Mission Control Spaces if they (a) are wanted by this user
  # and (b) they haven’t already been set.
  report_start_phase_standard
  
  if test_genomac_user_state "$SESH_WALLPAPERS_USER_WANTS_THEM"; then
    run_if_user_has_not_done "$PERM_WALLPAPERS_HAVE_BEEN_SET" \
      set_wallpapers_for_all_spaces \
      "Skipping deploying wallpapers, because they’ve already been deployed."
  fi
  
  report_end_phase_standard
}

function set_wallpapers_for_all_spaces() {
  # For each Mission Control Space, sets a wallpaper on each display of that Space.
  # Each display of a particular Space receives the same wallpaper.
  # Different Spaces can receive different wallpapers.
  report_start_phase_standard
  local wallpaper_path
  local -i number_of_current_space

  for (( number_of_current_space=1; number_of_current_space <= MAXIMUM_NUMBER_OF_MISSION_CONTROL_SPACES; ++number_of_current_space )); do
    move_to_mission_control_space_n $number_of_current_space
    sleep 1
    wallpaper_path="(( $get_path_to_wallpaper_for_mission_control_space_n $number_of_current_space ))"
    sleep 1
    set_all_displays_of_current_mission_control_space_to_image_at_path "$wallpaper_path"
  done

  # Return to Space #1
  move_to_mission_control_space_n 1
  
  report_end_phase_standard
}

function set_all_displays_of_current_mission_control_space_to_image_at_path() {
  # Sets wallpaper of all displays of current Mission Control Space to image at supplied path.
  report_start_phase_standard
  local wallpaper_path="${1:?MISSING wallpaper_path}"

  osascript "$wallpaper_path" <<'APPLESCRIPT'
  on run argv
    set wallpaper_path to item 1 of argv
    tell application "System Events"
      tell every desktop to set picture to wallpaper_path
    end tell
  end run
  APPLESCRIPT

  report_end_phase_standard
}

function move_to_mission_control_space_n() {
  # Moves to desired Mission Control Space, specified by its number 1–16
  #
  # Relies on assumed already-implemented Hotkey assignments:
  #  1: ⌃⌥⌘1
  #  2: ⌃⌥⌘2
  #  …
  #  9: ⌃⌥⌘9
  # 10: ⌃⌥⌘0
  # 11: ⌃⌥⌘F1
  # …
  # 16: ⌃⌥⌘F6
  
  report_start_phase_standard
  local -i number_of_space_to_which_to_move=${1:MISSING number of space to move to}

  local key_code_for_requested_mission_control_space
  local key_code_from_mission_control_space_number

  key_code_from_mission_control_space_number=(18 19 20 21 13 22 26 28 25 29 122 120 99 118 96 97)
  
  key_code_for_requested_mission_control_space=${key_code_from_mission_control_space_number[$number_of_space_to_which_to_move]}

  osascript "$key_code_for_requested_mission_control_space" <<'APPLESCRIPT'
  on run argv
    set key_code_for_requested_mission_control_space to item 1 of argv
    tell application "System Events"
      key code key_code_for_requested_mission_control_space using {control down, option down, command down}
    end tell
  end run
  APPLESCRIPT
  
  report_end_phase_standard
}

function get_path_to_wallpaper_for_mission_control_space_n() {
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard
  report_end_phase_standard
}
