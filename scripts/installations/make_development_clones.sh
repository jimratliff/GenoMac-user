#!/usr/bin/env zsh

function conditionally_clone_GenoMac_repos_for_development() {
  # If user has 'genomac-developer' attribute, make additional clones of GenoMac-system
  # and GenoMac-user for development.
  report_start_phase_standard

  if test_genomac_user_state "$SESH_USER_IS_A_GENOMAC_DEVELOPER"; then

    ############### BEGIN: REMOVE AFTER 1PASSWORD SSH AGENT IS FIXED TO WORK WITH USERS ON A NON-STARTUP VOLUME ###############
    if user_home_directory_is_on_startup_volume; then
      report_warning "Skipping making dev clones of GenoMac repos, because 1Password isn’t compatible with users on a non-startup volume."
      report_end_phase_standard
      return 0
    fi
    ############### END: REMOVE AFTER 1PASSWORD SSH AGENT IS FIXED TO WORK WITH USERS ON A NON-STARTUP VOLUME ###############

    run_if_user_has_not_done "$PERM_GENOMAC_DEV_CLONES_HAVE_BEEN_CREATED" \
      make_additional_dev_clones_of_genomac_repos \
      "Skipping making development clones of GenoMac repos, because they’ve already been created in the past."
  else
    report_to_log "Skipping making additional development clones of GenoMac repos,${NEWLINE}because user doesn’t want to develop Project GenoMac."
  fi
  
  report_end_phase_standard
}

function make_additional_dev_clones_of_genomac_repos() {
  # Makes separate development clones of GenoMac-system, GenoMac-user, GenoMac-shared,
  # and GenoMac-private in $GENOMAC_DEVELOPMENT_DIRECTORY.
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

  # Uses `:` as delimiter between adjacent elements
  repo_specs=(
    "--public:${GENOMAC_SYSTEM_REPO_NAME}:genomac-system"
    "--public:${GENOMAC_USER_REPO_NAME}:genomac-user"
    "--public:${GENOMAC_SHARED_REPO_NAME}:genomac-shared"
    "--private:${GENOMAC_PRIVATE_REPO_NAME}:genomac-private"
  )

  for repo_spec in "${repo_specs[@]}"; do
    local -a repo_fields
    repo_fields=("${(@s/:/)repo_spec}")
  
    repo_visibility="${repo_fields[1]}"
    github_repo_name="${repo_fields[2]}"
    local_repo_dir_name="${repo_fields[3]}"
    local_repo_dir="${GENOMAC_DEVELOPMENT_DIRECTORY}/${local_repo_dir_name}"
  
    clone_genomac_repo \
      "$repo_visibility" \
      "$github_repo_name" \
      "$local_repo_dir"
  
    if [[ "$repo_visibility" == "--public" ]]; then
      configure_split_remote_URLs_for_public_GitHub_repo_if_cloned \
        "$local_repo_dir" \
        "$github_repo_name"
    fi
  done

  report_end_phase_standard
}
