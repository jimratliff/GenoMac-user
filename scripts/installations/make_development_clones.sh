#!/usr/bin/env zsh

function conditionally_clone_GenoMac_repos_for_development() {
  # If user has 'genomac-developer' attribute, make additional clones of GenoMac-system
  # and GenoMac-user for development.
  report_start_phase_standard

  if test_genomac_user_state "$PERM_USER_IS_A_GENOMAC_DEVELOPER"; then
    run_if_user_has_not_done "$PERM_GENOMAC_DEV_CLONES_HAVE_BEEN_CREATED" \
      make_additional_dev_clones_of_genomac_repos \
      "Skipping making development clones of GenoMac repos,${NEWLINE}because they’ve already been created in the past."
  else
    report_to_log "Skipping making additional development clones of GenoMac repos,${NEWLINE}because user doesn’t want to develop Project GenoMac."
  fi
  
  report_end_phase_standard
}

function make_additional_dev_clones_of_genomac_repos() {
  # Makes a separate development clone of each of GenoMac-system, GenoMac-user, and GenoMac-shared
  # in $GENOMAC_DEVELOPMENT_DIRECTORY
  #
  # Gives a WARNING whenever one of these directories already exists in the desired location.
  #
  # Hint: GENOMAC_DEVELOPMENT_DIRECTORY=$HOME/Repositories/Project_GenoMac
  report_start_phase_standard
  report_end_phase_standard
}
