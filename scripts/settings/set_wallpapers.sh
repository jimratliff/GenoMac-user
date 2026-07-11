#!/usr/bin/env zsh

function conditionally_set_wallpapers_for_all_spaces() {
  # Set wallpapers for all Mission Control Spaces if they (a) are wanted by this user
  # and (b) they haven’t already been set.
  report_start_phase_standard
  
  if test_genomac_user_state "$SESH_WALLPAPERS_USER_WANTS_THEM"; then
    if ! test_genomac_user_state "$PERM_MISSION_CONTROL_SPACES_CREATED"; then
      report_warning "User wants multiple wallpapers, but multiple Mission Control Spaces haven’t been created.${NEWLINE}Skipping wallpaper assignments."
      report_end_phase_standard
      return 0
    fi
    
    run_if_user_has_not_done "$PERM_WALLPAPERS_HAVE_BEEN_SET" \
      set_wallpapers_for_all_spaces \
      "Skipping deploying wallpapers, because they’ve already been deployed."
  else
    report_to_log "Skipping deploying wallpapers, because this user doesn’t want them."
  fi
  
  report_end_phase_standard
}

function set_wallpapers_for_all_spaces() {
  # For each Mission Control Space, sets a wallpaper on each display of that Space.
  # Each display of a particular Space receives the same wallpaper as the other displays of the same Space.
  # Different Spaces can receive different wallpapers.
  report_start_phase_standard
  local wallpaper_path
  local -i number_of_current_space

  for (( number_of_current_space=1; number_of_current_space <= MAXIMUM_NUMBER_OF_MISSION_CONTROL_SPACES; ++number_of_current_space )); do
    move_to_mission_control_space_n "$number_of_current_space"
    sleep 1
    wallpaper_path="$($get_path_to_wallpaper_for_mission_control_space_n "$number_of_current_space")"
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
  local -i number_of_space_to_which_to_move
  number_of_space_to_which_to_move="${1:?MISSING number of space to move to}"

  local key_code_for_requested_mission_control_space
  local -i key_code_from_mission_control_space_number
  local -a key_code_from_mission_control_space_number=(18 19 20 21 13 22 26 28 25 29 122 120 99 118 96 97)
  
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

  local -i number_of_mission_control_space
  number_of_mission_control_space="${1:?MISSING number_of_mission_control_space}"

  local user_wallpaper_directory
  local path_of_matching_item
  local path_of_wallpaper
  local candidate_path

  local -a matching_items
  local -a directory_entries

  # HINT: USER_WALLPAPER_DIRECTORY="${LOCAL_DROPBOX_DIRECTORY}/Users/${USER}/Prefs/Mission_Control_wallpapers"
  user_wallpaper_directory="$USER_WALLPAPER_DIRECTORY"

  if (( number_of_mission_control_space < 1 ||
        number_of_mission_control_space > MAXIMUM_NUMBER_OF_MISSION_CONTROL_SPACES )); then
    report_fail \
      "Invalid Mission Control Space number: ${number_of_mission_control_space}"
    return 1
  fi

  if [[ ! -d "$user_wallpaper_directory" ]]; then
    report_fail "Wallpaper directory does not exist: ${user_wallpaper_directory}"
    return 1
  fi

  matching_items=("${user_wallpaper_directory}/${number_of_mission_control_space}_"*(N.on))

  if (( ${#matching_items} == 0 )); then
    report_fail "No wallpaper file or directory was found for Mission Control Space ${number_of_mission_control_space} in: ${user_wallpaper_directory}"
    return 1
  fi

  path_of_matching_item="${matching_items[1]}"

  if [[ -f "$path_of_matching_item" ]]; then
    if ! extension_is_valid_wallpaper_image_type "$path_of_matching_item"; then
      report_fail "The item assigned to Mission Control Space ${number_of_mission_control_space} is not a valid wallpaper image: ${path_of_matching_item}"
      return 1
    fi

    path_of_wallpaper="$path_of_matching_item"

  elif [[ -d "$path_of_matching_item" ]]; then
    directory_entries=("${path_of_matching_item}"/*(N.on))

    for candidate_path in "${directory_entries[@]}"; do
      if [[ -f "$candidate_path" ]] &&
         extension_is_valid_wallpaper_image_type "$candidate_path"; then
        path_of_wallpaper="$candidate_path"
        break
      fi
    done

    if [[ -z "$path_of_wallpaper" ]]; then
      report_fail "No valid wallpaper image was found in the directory assigned to Mission Control Space ${number_of_mission_control_space}: ${path_of_matching_item}"
      return 1
    fi

  else
    report_fail "The item assigned to Mission Control Space ${number_of_mission_control_space} is neither a regular file nor a directory: ${path_of_matching_item}"
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
      return 0
      ;;
    *)
      return 1
      ;;
  esac
  report_end_phase_standard
}
