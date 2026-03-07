#!/usr/bin/env zsh

# DEPRECATED: The icon theme is now auto-installed by Zed per its settings file

function conditionally_install_zed_icon_theme() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_ZED_ICON_THEME_HAS_BEEN_INSTALLED_FOR_USER" \
    install_zed_icon_theme_for_user \
    "Skipping installation of Zed icon theme, because it has been installed for this user in the past."

  report_end_phase_standard
}

function install_zed_icon_theme_for_user() {
  # Expects the icon theme to be supplied as a `vscode-icons.zip` file in
  # resources/zed/extension/icon_theme in this repo.
  
  report_start_phase_standard

  local zed_icon_theme_directory="${HOME}/Library/Application Support/Zed/extensions/installed"
  local icon_theme_directory_name_as_installed="vscode-icons"

  # Hint: GMU_RESOURCES="${GENOMAC_USER_LOCAL_DIRECTORY}/resources" = GMU_RESOURCES="$HOME/.genomac-user/resources"
  local zip_source="${GMU_RESOURCES}/zed/extension/icon_theme/vscode-icons.zip"

  copy_resource_between_local_directories \
    "${zip_source}" \
    "${zed_icon_theme_directory}/${icon_theme_directory_name_as_installed}" \
    --unzip

  report_end_phase_standard
}
