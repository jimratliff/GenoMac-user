#!/usr/bin/env zsh

function conditionally_clone_GenoMac_repos_for_development() {
  # If user has 'genomac-developer' attribute, make additional clones of GenoMac-system
  # and GenoMac-user for development.
  report_start_phase_standard

  if test_genomac_user_state "$SESH_USER_IS_A_GENOMAC_DEVELOPER"; then/
    run_if_user_has_not_done "$PERM_GENOMAC_DEV_CLONES_HAVE_BEEN_CREATED" \
      make_additional_dev_clones_of_genomac_repos \
      "Skipping making development clones of GenoMac repos,${NEWLINE}because they’ve already been created in the past."
  else
    report_to_log "Skipping making additional development clones of GenoMac repos,${NEWLINE}because user doesn’t want to develop Project GenoMac."
  fi
  
  report_end_phase_standard
}

function make_additional_dev_clones_of_genomac_repos() {
  # Makes separate development clones of GenoMac-system, GenoMac-user, and GenoMac-shared
  # in $GENOMAC_DEVELOPMENT_DIRECTORY.
  #
  # These development clones are separate from the execution clones at:
  #   ~/.genomac-system
  #   ~/.genomac-user
  #
  # Gives a WARNING whenever one of the desired repo directories already exists.
  #
  # Expected:
  #   USER_LOCAL_REPOSITORY_DIRECTORY="$HOME/Repositories"
  #   GENOMAC_DEVELOPMENT_DIRECTORY="$HOME/Repositories/Project_GenoMac"

  report_start_phase_standard

  local -a repo_specs
  local repo_spec
  local github_repo_name
  local local_repo_dir_name
  local local_repo_dir

  create_repositories_directory_for_developers
  
  report_action_taken "Create GenoMac development directory, if necessary: ${GENOMAC_DEVELOPMENT_DIRECTORY}"
  mkdir -p "$GENOMAC_DEVELOPMENT_DIRECTORY" ; success_or_not
  
  report_adjust_setting "Set permissions on GenoMac development directory"
  chmod 700 "$GENOMAC_DEVELOPMENT_DIRECTORY" ; success_or_not

  repo_specs=(
    "${GENOMAC_SYSTEM_REPO_NAME}:genomac-system"
    "${GENOMAC_USER_REPO_NAME}:genomac-user"
    "${GENOMAC_SHARED_REPO_NAME}:genomac-shared"
    "${GENOMAC_PRIVATE_REPO_NAME}:genomac-private"
  )

  for repo_spec in "${repo_specs[@]}"; do
    github_repo_name="${repo_spec%%:*}"
    local_repo_dir_name="${repo_spec#*:}"
    local_repo_dir="${GENOMAC_DEVELOPMENT_DIRECTORY}/${local_repo_dir_name}"

    clone_public_genomac_repo_using_HTTPS "$github_repo_name" "$local_repo_dir"

    configure_split_remote_URLs_for_public_GitHub_repo_if_cloned \
      "$local_repo_dir" \
      "$github_repo_name"
  done

  report_end_phase_standard
}
