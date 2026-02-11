#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/web_extension_data_gecko.sh"

function conditionally_set_waterfox_settings() {
  report_start_phase_standard

  report_end_phase_standard
}

############### WIP!



function install_waterfox_extensions() {

  # Note: The toolbar for Preview.app is separately configured by bootstrap_preview_app.sh

  report_start_phase_standard
  report_action_taken "Install web-browser extensions into Waterfox"
  
  
  
  report_end_phase_standard

}
