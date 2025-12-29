# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function install_btt_license_file() {
  # To be run only once per user to install the BetterTouchTool license file.
  
  report_start_phase_standard
  report_action_taken "Bootstrap-only installation of BetterTouchTool license file."

  local license_file_name="bettertouchtool.bttlicense"
  
  local origin_subpath="BetterTouchTool/LICENSE/${license_file_name}"
  
  local origin_path="${GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY}/${origin_subpath}"
  
  local destination_directory="$HOME/Library/Application Support/BetterTouchTool"

  local destination_path="${destination_directory}/${license_file_name}"
  
  report_action_taken "Verify that source license file exists"
  if [[ ! -f "$origin_path" ]]; then
    report_fail "Source license file not found at: $origin_path"
    report_end_phase_standard
    return 1
  fi
  report_success "Source license file verified: $origin_path"
  
  report_action_taken "Ensure destination folder exists: $destination_directory"
  mkdir -p "$destination_directory" ; success_or_not

  report_action_taken "Copy ${license_file_name} to ${destination_directory} (idempotent)"
  # Copy the file if (a) it doesn’t exist at the destination or (b) it exists at the destination 
  # but is different than the source.
  if [[ ! -e "$destination_path" ]] || ! cmp -s "$origin_path" "$destination_path"; then
    cp -f "$origin_path" "$destination_path" ; success_or_not
    report_success "Installed or updated ${license_file_name}"

    report_action_taken "Set ownership and permissions on ${destination_path}."
    chmod 600 "$destination_path" ; success_or_not
    chown "$USER" "$destination_path" ; success_or_not
  else
    report_success "${license_file_name} already up to date"
  fi
  
  report_end_phase_standard
}
