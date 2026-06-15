#!/usr/bin/env zsh

function conditionally_create_repositories_directory_for_developers() {
  # Creates Repositories directory for developers if user wants that.
  #
  # Doesn’t track (e.g., with a PERM state) whether this directory has been created before because
  # it’s just as easy to do a `mkdir -p`
  report_start_phase_standard
  if test_genomac_user_state "$SESH_REPOSITORIES_DIRECTORY_USER_WANTS_IT"; then
    create_repositories_directory_for_developers
  else
    report "Skipping creation of repositories directory for developers, because this user isn’t a developer."
  fi
  report_end_phase_standard
}

function create_repositories_directory_for_developers() {
  # Creates Repositories directory for developers
  report_start_phase_standard
  report_action_taken "Create local repositories directory, if necessary: ${USER_LOCAL_REPOSITORY_DIRECTORY}"
  mkdir -p "$USER_LOCAL_REPOSITORY_DIRECTORY" ; success_or_not
  
  report_adjust_setting "Set permissions on local repositories directory"
  chmod 700 "$USER_LOCAL_REPOSITORY_DIRECTORY" ; success_or_not
  report_end_phase_standard
}
