#!/usr/bin/env zsh

function create_directory_for_obsidian_vaults() {
  # Creates directory for Obsidian vaults
  #
  # Hint: USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY="$HOME/Documents/Obsidian_vaults"
  report_start_phase_standard
  
  report_action_taken "Create local directory for Obsidian vaults, if necessary: ${USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY}"
  mkdir -p "$USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY" ; success_or_not
  
  report_adjust_setting "Set permissions on local Obsidian-vaults directory"
  chmod 755 "$USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY" ; success_or_not
  
  report_end_phase_standard
}

############### BELOW IS DEPRECATED ###############

# function conditionally_create_directory_for_obsidian_vaults() {
#   # Creates directory for Obsidian vaults, if user uses Obsidian.
#   #
#   # Hint: USER_LOCAL_OBSIDIAN_VAULTS_DIRECTORY="$HOME/Documents/Obsidian_vaults"
#   #
#   # Doesn’t track (e.g., with a PERM state) whether this directory has been created before because
#   # it’s just as easy to do a `mkdir -p`
#   report_start_phase_standard
#   
#   if test_genomac_user_state "$SESH_OBSIDIAN_USER_WANTS_IT"; then
#     create_directory_for_obsidian_vaults
#   else
#     report "Skipping creation of Obsidian-vaults directory, because this user doesn’t want Obsidian."
#   fi
#   
#   report_end_phase_standard
# }
