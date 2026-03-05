#!/usr/bin/env zsh

function conditionally_install_witch_prefpane_for_user() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_WITCH_HAS_BEEN_INSTALLED_FOR_USER" \
    install_witch_prefpane_for_user \
    "Skipping installation of Witch, because it has been installed for this user in the past."

  report_end_phase_standard
}

function install_witch_prefpane_for_user() {
  # Installs Witch.prefPane for *only this user* from a zipped copy stored in the
  # at .genomac-user/resources/witch/witch_prefpane.zip.
  #
  # Installs to ~/Library/PreferencePanes/Witch.prefPane ($WITCH_PATH_TO_USER_PREFPANE) so the pane 
  # is available for this user.
  #
  # This is a bootstrap function: Any existing prefPane at the destination is overwritten.
  # Anticipated to be called by conditionally_install_witch_prefpane_for_user(), which calls this only
  # if (a) initial bootstrap or (b) a new version has been licensed, in response to which
  # PERM_WITCH_HAS_BEEN_INSTALLED_FOR_USER was deleted to trigger an installation of the newer 
  # licensed version.

  report_start_phase_standard
  report_action_taken "Installing Witch preference pane for use by this user"

  # Hint: WITCH_PREFPANE_NAME="Witch.prefPane"
  # Hint: GMU_RESOURCES="${GENOMAC_USER_LOCAL_DIRECTORY}/resources" = GMU_RESOURCES="$HOME/.genomac-user/resources"
  
  local zip_source="${GMU_RESOURCES}/witch/witch_prefpane.zip"

  report_action_taken "Installing ${WITCH_PREFPANE_NAME} to ${WITCH_PATH_TO_USER_PREFPANE}"
  copy_resource_between_local_directories \
    "$zip_source" \
    "$WITCH_PATH_TO_USER_PREFPANE" \
    --unzip
    
  local result=$?
  success_or_not

  report_end_phase_standard
  return $result
}
