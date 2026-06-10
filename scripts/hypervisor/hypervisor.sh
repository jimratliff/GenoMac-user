#!/usr/bin/env zsh

set -euo pipefail

# Source environment variables corresponding to enums for states
safe_source "${GMU_HYPERVISOR_SCRIPTS}/assign_enum_env_vars_for_states.sh"

safe_source "${GMU_HYPERVISOR_SCRIPTS}/subdermis.sh"

function hypervisor() {
  # The outermost “dermal” layer of hypervisory supervison (the dermis). Ensures the 
  # GenoMac-user repository is updated before running the subdermal layer (subdermis). 
  #
  # Compares the local clone against the remote repo to determine whether there are unpulled
  # changes. If so, updates the local clone and restarts this script. Otherwise, hand
  # control off to the subdermal layer (subdermis). The next time through, still under the
  # same “session,” the local won’t be tested against the remote, and thus control will
  # pass immediately to subdermis.
  #
  # It assumes that:
  # - GenoMac-user has been cloned locally to GENOMAC_USER_LOCAL_DIRECTORY (~/.genomac-user).
  #   - It is *not* necessary to update the clone before running this function, because this function
  #     updates the clone.
  # - scripts/0_initialize_me_first.sh has been sourced
  #   - This sources (a) helpers and cross-repo environment variables from GenoMac-shared and
  #     (b) repo-specific environment variables.
  
  report_start_phase_standard

  # See GenoMac-shared/scripts/helpers-git.sh
  # Tests whether repo $GENOMAC_USER_REPO_NAME has already been checked for remote changes
  # during this session. If not, check the remote. If the local clone is updated, mark the repo
  # as checked and re-execute the Hypervisor.
  # The first time through in a session, the state file"$SESH_REPO_HAS_BEEN_TESTED_FOR_CHANGES"
  # doesn’t exist because all SESH… states are deleted at the end of the previous session.
  refresh_repo_from_remote_and_reexecute_hypervisor_if_updated \
    test_genomac_user_state \
    set_genomac_user_state \
    "$SESH_REPO_HAS_BEEN_TESTED_FOR_CHANGES" \
    "$GENOMAC_USER_REPO_NAME" \
    "$GENOMAC_USER_LOCAL_DIRECTORY"

  # Locally configures clone of public GitHub repo to (a) fetch without authentication 
  # using HTTPS but (b) push using SSH. (Although the following needs to be performed only once,
  # it’s simpler to always do it than to test whether it’s been done before.)
  configure_split_remote_URLs_for_GenoMac_user

  ############### BEGIN MIGRATIONS
  # Provide any migrations here
  # Example:
  #   migrate_user_states "MIGRATION_ID_2026_03_11" --delete "$PERM_PREVIEW_BASE_TOOLBAR_HAS_BEEN_SPECIFIED"

  ############### END MIGRATIONS

  # Run the subdermal layer of the hypervisor, which supervises the remainder of the process.
  subdermis

  # Reset SESH states for next session
  delete_all_user_SESH_states
  
  output_hypervisor_departure_banner "$GENOMAC_SCOPE_USER"
  
  hypervisor_force_logout --final

  report_end_phase_standard
}
