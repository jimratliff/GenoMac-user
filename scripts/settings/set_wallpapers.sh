#!/usr/bin/env zsh

function conditionally_set_single_space_wallpaper() {
  # Set a wallpaper for a single-Space user (i.e., either USER_CONFIGURER or USER_SWITCHER)
  # if (a) it is wanted by this user and (b) it hasn’t already been set.
  report_start_phase_standard

  if test_genomac_user_state "$SESH_WALLPAPER_CONFIGURER_USER_WANTS_IT"; then
    conditionally_set_wallpaper_for_user_configurer
  elif test_genomac_user_state "$SESH_WALLPAPER_SWITCHER_USER_WANTS_IT"; then
    conditionally_set_wallpaper_for_user_switcher
  else
    report_to_log "Skipping setting any single-space wallpaper, because this user doesn’t want it."
    report_end_phase_standard
    return 0
  fi
}

function conditionally_set_wallpaper_for_user_configurer() {
  # Set wallpaper for USER_CONFIGURER if it hasn’t been done already
  report_start_phase_standard
  
  run_if_user_has_not_done "$PERM_WALLPAPER_CONFIGURER_USER_HAS_BEEN_SET" \
    set_wallpaper_for_user_configurer \
    "Skipping setting wallpaper for USER_CONFIGURER, because it’s already been deployed."
    
  report_end_phase_standard
}

function conditionally_set_wallpaper_for_user_switcher() {
  # Set wallpaper for the “switcher” user if it hasn’t been done already
  report_start_phase_standard
  
  run_if_user_has_not_done "$PERM_WALLPAPER_SWITCHER_USER_HAS_BEEN_SET" \
    set_wallpaper_for_user_switcher \
    "Skipping setting wallpaper for “switcher” user, because it’s already been deployed."
    
  report_end_phase_standard
}

function set_wallpaper_for_user_configurer() {
  # Set wallpaper for USER_CONFIGURER
  report_start_phase_standard
  
  local wallpaper_path
  wallpaper_path="$GMU_WALLPAPER_CONFIGURER"
  set_all_displays_of_current_mission_control_space_to_image_at_path "$wallpaper_path"
  
  report_end_phase_standard
}

function set_wallpaper_for_user_switcher() {
  # Set wallpaper for “switcher” user
  report_start_phase_standard
  
  local wallpaper_path
  wallpaper_path="$GMU_WALLPAPER_SWITCHER"
  set_all_displays_of_current_mission_control_space_to_image_at_path "$wallpaper_path"
  
  report_end_phase_standard
}

function conditionally_set_wallpapers_for_all_spaces() {
  # Set wallpapers for all Mission Control Spaces if they (a) are wanted by this user
  # and (b) they haven’t already been set.
  report_start_phase_standard
  
  if ! test_genomac_user_state "$SESH_WALLPAPERS_USER_WANTS_THEM"; then
    report_to_log "Skipping deploying wallpapers, because this user doesn’t want them."
    report_end_phase_standard
    return 0
  fi
  
  if ! test_genomac_user_state "$PERM_MISSION_CONTROL_SPACES_CREATED"; then
    report_warning "User wants multiple wallpapers, but multiple Mission Control Spaces haven’t been created.${NEWLINE}Skipping wallpaper assignments."
    report_end_phase_standard
    return 0
  fi
  
  run_if_user_has_not_done "$PERM_WALLPAPERS_HAVE_BEEN_SET" \
    set_wallpapers_for_all_spaces \
    "Skipping deploying wallpapers, because they’ve already been deployed."
  
  report_end_phase_standard
}

function set_wallpapers_for_all_spaces() {
  # For each Mission Control Space, sets a wallpaper on each display of that Space.
  # Each display of a particular Space receives the same wallpaper as the other displays of the same Space.
  # Different Spaces can receive different wallpapers.
  report_start_phase_standard
  local wallpaper_path
  local -i number_of_current_space

  report_action_taken "Assign specified wallpaper to each Mission Control Space."

  # Current terminal must have Accessibility permissions in order for AppleScript to emit keystrokes to navigate from
  # Space to Space
  interactive_ensure_terminal_has_accessibility     # scripts/settings/interactive_set_permissions.sh

  for (( number_of_current_space=1; number_of_current_space <= MAXIMUM_NUMBER_OF_MISSION_CONTROL_SPACES; ++number_of_current_space )); do
    move_to_mission_control_space_n "$number_of_current_space"
    wallpaper_path="$(get_path_to_wallpaper_for_mission_control_space_n "$number_of_current_space")"

    report_to_log "Space ${number_of_current_space} path: ${wallpaper_path}"
  
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

  local sleeptime_to_allow_deployment_of_wallpapers_to_all_desktop_in_given_space=1

  report_to_log "Current wallpaper path:${NEWLINE}${wallpaper_path}"

  osascript - "$wallpaper_path" <<'APPLESCRIPT'
on run argv
  set wallpaper_path to item 1 of argv
  tell application "System Events"
    tell every desktop to set picture to wallpaper_path
  end tell
end run
APPLESCRIPT

  sleep "$sleeptime_to_allow_deployment_of_wallpapers_to_all_desktop_in_given_space"
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
  
  report_start_phase "Entering move_to_mission_control_space_n : $*"
  
  local sleeptime_to_allow_for_navigation_to_new_space=1
  local -i number_of_space_to_which_to_move
  number_of_space_to_which_to_move="${1:?MISSING number of space to move to}"

  local key_code_for_requested_mission_control_space
  local -a key_code_from_mission_control_space_number=(18 19 20 21 23 22 26 28 25 29 122 120 99 118 96 97)
  
  key_code_for_requested_mission_control_space=${key_code_from_mission_control_space_number[$number_of_space_to_which_to_move]}

  osascript - "$key_code_for_requested_mission_control_space" <<'APPLESCRIPT'
  on run argv
    set key_code_for_requested_mission_control_space to (item 1 of argv) as integer
    tell application "System Events"
      key code key_code_for_requested_mission_control_space using {control down, option down, command down}
    end tell
  end run
APPLESCRIPT

  sleep "$sleeptime_to_allow_for_navigation_to_new_space"
  report_end_phase "Leaving move_to_mission_control_space_n : $*"
}

function validate_number_of_mission_control_space() {
  # Fatally errors if supplied number is not a valid number for a Mission Control Space.
  report_start_phase_standard
  local space_number="${1:?missing number of Mission Control Space}"

  if (( space_number < 1 ||
        space_number > MAXIMUM_NUMBER_OF_MISSION_CONTROL_SPACES )); then
    report_fail "Invalid Mission Control Space number: ${space_number}"
    return 1
  fi
  
  report_end_phase_standard
}

function get_wallpaper_container_path_for_space_number() {
  # Returns path to item (file or directory) in wallpaper directory that is or immediately
  # contains the wallpaper for the given Space number.
  #
  # The “container” for a wallpaper is either:
  # - the wallpaper file itself, if it is at the root of USER_WALLPAPER_DIRECTORY
  # - the immediate subdirectory of USER_WALLPAPER_DIRECTORY that immediately contains the wallpaper
  # 
  # The name of the container is encoded with a prefix of the form '1_' or '12_', followed by a string
  # that is converted to the name of the associated Space (by replacing any embedded underscores with spaces).

  report_start_phase_standard

  local -i space_number="${1:?missing space number}"
  validate_number_of_mission_control_space

  # HINT: USER_WALLPAPER_DIRECTORY="${LOCAL_DROPBOX_DIRECTORY}/Users/${USER}/Prefs/Mission_Control_wallpapers"
  local user_wallpaper_directory
  user_wallpaper_directory="$USER_WALLPAPER_DIRECTORY
  if [[ ! -d "$user_wallpaper_directory" ]]; then
    report_fail "Wallpaper directory does not exist: ${user_wallpaper_directory}"
    return 1
  fi

  # Find the unique matching file or directory that has the prefix "${space_number}_"
  local -a matching_items
  matching_items=("${user_wallpaper_directory}/${space_number}_"*(Non))
  if (( ${#matching_items} == 0 )); then
    report_fail "No wallpaper file or directory was found for Mission Control Space ${space_number} in: ${user_wallpaper_directory}"
    return 1
  fi

  local path_of_wallpaper_container
  path_of_wallpaper_container="${matching_items[1]}"
  print -r -- "$path_of_wallpaper_container"
  
  report_end_phase_standard
}

function get_path_to_wallpaper_for_mission_control_space_n() {
  # Prints to stdout the path of the wallpaper assigned to the supplied Mission
  # Control Space, referenced by number 1–16.
  #
  # Looks in user_wallpaper_directory for the alphabetically first file or
  # directory whose name begins with:
  #   1_, 2_, …, 9_, 10_, …, 16_
  # corresponding to number_of_mission_control_space.
  #
  # If that match is a file, confirms that it has a valid wallpaper-image
  # extension.
  #
  # If that match is a directory, selects the alphabetically first regular file
  # directly within that directory that has a valid wallpaper-image extension.
  #
  # Returns nonzero if no suitable wallpaper can be found.
  
  report_start_phase_standard

  local -i space_number="${1:?missing space number}"
  validate_number_of_mission_control_space

  local path_of_wallpaper
  local candidate_path

  local -a directory_entries

  local path_of_wallpaper_container
  path_of_wallpaper_container="$(get_wallpaper_container_path_for_space_number "$space_number")"

  if [[ -f "$path_of_wallpaper_container" ]]; then
  
    if ! extension_is_valid_wallpaper_image_type "$path_of_wallpaper_container"; then
      report_fail "The file assigned to Mission Control Space ${space_number} is not a valid wallpaper image: ${path_of_wallpaper_container}"
      return 1
    fi

    path_of_wallpaper="$path_of_wallpaper_container"

  elif [[ -d "$path_of_wallpaper_container" ]]; then
  
    directory_entries=("${path_of_wallpaper_container}"/*(Non))
    
    for candidate_path in "${directory_entries[@]}"; do
      if [[ -f "$candidate_path" ]] && extension_is_valid_wallpaper_image_type "$candidate_path"; then
        path_of_wallpaper="$candidate_path"
        break
      fi
    done

    if [[ -z "$path_of_wallpaper" ]]; then
      report_fail "No valid wallpaper image was found in the directory “${path_of_wallpaper_container}” assigned to Mission Control Space ${space_number}."
      return 1
    fi

  else
    report_fail "The item assigned to Mission Control Space ${space_number} is neither a regular file nor a directory: ${path_of_wallpaper_container}"
    return 1
  fi

  print -r -- "$path_of_wallpaper"
  report_end_phase_standard
}

function extension_is_valid_wallpaper_image_type() {
  # Returns 0 if the supplied path has a filename extension valid for use as
  # a wallpaper image. Returns 1 otherwise.
  report_start_phase_standard
  local path="${1:?MISSING path}"
  local extension="${${path:e}:l}"

  case "$extension" in
    jpeg|jpg|heic|png|tiff|webp)
      report_to_log "Extension $extension is a valid wallpaper image type."
      report_end_phase_standard
      return 0
      ;;
    *)
      report_fail "Extension $extension is NOT a valid wallpaper image type."
      report_end_phase_standard
      return 1
      ;;
  esac
}
