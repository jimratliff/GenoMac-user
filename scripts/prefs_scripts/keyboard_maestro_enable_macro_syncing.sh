# This file assumes:
# - GENOMAC_HELPER_DIR is already set in the current shell to the absolute path of the directory 
#   containing helpers.sh.
# - PLISTBUDDY_PATH
# These environment variables must be defined by assign_environment_variables.sh

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function enable_keyboard_maestro_macro_syncing() {

  # Status as of 12/30/2025: EXPERIMENTAL
  # `make defaults-detective` perceived only one change following turning macro-syncing on,
  # and the current function addresses that change.
  # It is possible that the process of turning on syncing had additional side effects not replicated
  # by this function.

  report_start_phase_standard
  report_action_taken "Enable Keyboard Maestro macro syncing"
  
  local domain_editor="com.stairways.keyboardmaestro.editor"
  
  local bundle_id_engine="com.stairways.keyboardmaestro.engine"
  local bundle_id_editor="com.stairways.keyboardmaestro.editor"
  
  local macro_file_name="Keyboard Maestro Macros.kmsync"
  local path_to_Keyboard_Maestro_subdirectory_in_Dropbox="$GENOMAC_USER_DROPBOX_DIRECTORY/Keyboard_Maestro"
  local macro_file_path="${path_to_Keyboard_Maestro_subdirectory_in_Dropbox}/${macro_file_name}"
  
  report_action_taken "Quit Keyboard Maestro if running to allow changing its settings"
  report_adjust_setting "Quitting the Editor"
  quit_app_by_bundle_id_if_running "$bundle_id_editor" ; success_or_not
  report_adjust_setting "Quitting the Engine"
  quit_app_by_bundle_id_if_running "$bundle_id_engine" ; success_or_not
  
  # Editor settings
  report_adjust_setting "Set: Path to Keyboard Maestro macro file in Dropbox"
  defaults write $domain_editor MacroSharingFile -string macro_file_path ; success_or_not
  
  report_end_phase_standard

}
