#!/usr/bin/env zsh

# Witch seems not to behave well when it is installed centrally for all users in the sense that it
# won’t automatically launch at login.
# 
# Instead, Witch needs to be installed independently for *each user*.
# 
# See [Why doesn't Witch launch at login in macOS Catalina?](https://manytricks.com/osticket/kb/faq.php?id=116).

function conditionally_install_witch_prefpane_for_user() {
  report_start_phase_standard

  run_if_system_has_not_done \
    "$PERM_WITCH_HAS_BEEN_INSTALLED_FOR_USER" \
    install_witch_prefpane_for_user \
    "Skipping installation of Witch, because it has been installed for this user in the past."

  report_end_phase_standard
}

function install_witch_prefpane_for_user() {
  # Installs Witch.prefPane for *only this user* from a zipped copy stored in the
  # at .genomac-user/resources/witch/witch_prefpane.zip.
  #
  # Installs to ~/Library/PreferencePanes/Witch.prefPane so the pane is available for this user.
  #
  # This is a bootstrap function: Any existing prefPane at the destination is overwritten.
  # Anticipated to be called by conditionally_install_witch_prefpane_for_user(), which calls this only
  # if (a) initial bootstrap or (b) a new version has been licensed, in response to which
  # PERM_WITCH_HAS_BEEN_INSTALLED_FOR_USER was deleted to trigger an installation of the newer 
  # licensed version.

  report_start_phase_standard
  report_action_taken "Installing Witch preference pane for use by this user"

  local prefpane_name="Witch.prefPane"
  # Hint: GMU_RESOURCES="${GENOMAC_USER_LOCAL_DIRECTORY}/resources" = GMU_RESOURCES="$HOME/.genomac-user/resources"
  local zip_source="${GMU_RESOURCES}/witch/witch_prefpane.zip"
  local user_prefpanes_dir="$HOME/Library/PreferencePanes"
  local destination_path="${user_prefpanes_dir}/${prefpane_name}"

  if [[ ! -f "$zip_source" ]]; then
    report_warning "Zip of Witch preference pane not found at ${zip_source}"
    report_end_phase_standard
    return 1
  fi

  local temp_dir
  temp_dir="$(mktemp -d)"
  trap '[[ -n "${temp_dir:-}" ]] && rm -rf "$temp_dir"' EXIT

  report_action_taken "Unzipping ${zip_source}"
  unzip -q "$zip_source" -d "$temp_dir" ; success_or_not

  local source_path="${temp_dir}/${prefpane_name}"

  if [[ -z "$source_path" || ! -d "$source_path" ]]; then
    report_warning "${prefpane_name} not found inside ${zip_source}"
    report_end_phase_standard
    return 1
  fi

  report_action_taken "Installing ${prefpane_name} to ${destination_path}"
  copy_resource_between_local_directories \
    "$source_path" \
    "$destination_path" 
  local result=$?
  success_or_not

  report_end_phase_standard
  return $result
}
