#!/usr/bin/env zsh

function is_functionality_incompatible_with_user_because_not_on_startup_volume() {
  # Returns 0 if both:
  # (a) supplied environment variable indicates a particular incompatibility with
  #     users whose home directories aren’t on the startup volume still exists
  # (b) this user’s home directory isn’t on the startup volume
  #
  # If supplied argument is "true", then the incompatibility still exists.
  
  report_start_phase_standard
  
  local incompatibility_flag_string="${1:?MISSING incompatibility_flag_string}"

  # If the bug has been fixed, the functionality is available regardless of home-directory location.
  if [[ "${incompatibility_flag_string}" != "true" ]]; then
    report_end_phase_standard
    return 1
  fi

  # If the user's home directory is on the startup volume, the user isn’t affected by the bug.
  if user_home_directory_is_on_startup_volume; then
    report_end_phase_standard
    return 1
  fi

  # Bug still exists and this user's home directory is relocated.
  report_end_phase_standard
  return 0
}

function is_onepassword_ssh_agent_unavailable_for_this_user() {
  # Returns 0 if BOTH:
  #   (a) 1Password's SSH Agent is still incompatible with relocated home directories, and
  #   (b) this user's home directory is on a non-startup volume.
  #
  # Returns 1 otherwise.

  is_functionality_incompatible_with_user_because_not_on_startup_volume \
    "$ONEPASSWORD_STILL_INCOMPATIBLE_WITH_RELOCATED_HOME_DIRECTORIES" || return $?
}

function is_default_browser_utility_unavailable_for_this_user() {
  # Returns 0 if BOTH:
  #   (a) the default-browser CLI utility is still incompatible with relocated home directories, and
  #   (b) this user's home directory is on a non-startup volume.
  #
  # Returns 1 otherwise.

  is_functionality_incompatible_with_user_because_not_on_startup_volume \
    "$DEFAULT_BROWSER_UTILITY_STILL_INCOMPATIBLE_WITH_RELOCATED_HOME_DIRECTORIES" || return $?
}
