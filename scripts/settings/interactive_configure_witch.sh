#!/usr/bin/env zsh

############### WIP as of 2/26/2026 INCONSISTENT STATE

function conditionally_configure_witch() {
  report_start_phase_standard
  
  run_if_user_has_not_done "$PERM_WITCH_HAS_BEEN_CONFIGURED" \
    interactive_configure_witch \
    "Skipping configuring Witch, because it’s already been configured"
  
  report_end_phase_standard
}

function set_witch_settings() {
  report_start_phase_standard

  # TODO
  
  report_end_phase_standard
}

function interactive_configure_witch() {
  # Bootstrap Witch.app for activation of its license.
  #
  # Because my license file for Witch resides in a directory in the user’s Dropbox directory,
  # this bootstrapping step must wait until Dropbox is configured for the user. (It is up
  # to the hypervisor to perform this check before calling this function.)
  
  report_start_phase_standard

  report "Time to configure Witch! I’ll launch it, and open a window with instructions for next steps"

  # Specify folder that contains the `Alfred_5_preferences` directory that contains the Alfred preferences file
  # By opening this container folder, the executing user can drag the `Alfred_5_preferences` folder icon
  # into the Open-file dialog presented under Advanced » Syncing » Set preferences folder…
  local container_directory="$GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY/Alfred_preferences"
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Alfred_how_to_configure.md" \
	--show-folder "$container_directory" \
    "$BUNDLE_ID_ALFRED" \
    "Follow the instructions in the Quick Look window to configure Alfred"
  
  report_end_phase_standard
}

function enable_alfred_preferences_syncing() {
  # Status as of 1/16/2026: DEPRECATED
  # Even when the `syncfolder` defaults write key is successfully set to $Alfred_directory_in_Dropbox,
  #   Alfred doesn’t successfully pull workflows from it.
  # Diagnosis: Although Alfred internally stores the sync directory in this key, merely setting this key
  #            doesn’t by itself cause Alfred to that directory as the sync directory.
  # Conclusion: There’s no alternative to manually setting the Preferences » Advanced » Syncing setting.

  report_start_phase_standard
  report_action_taken "Enable Alfred preference syncing"

  # Hint: GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${LOCAL_DROPBOX_DIRECTORY}/Preferences_common"
  local Alfred_directory_in_Dropbox="$GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY/Alfred_preferences/Alfred_5_preferences"
  
  report_adjust_setting "Set: Path to Alfred preferences directory in Dropbox"
  defaults write $DEFAULTS_DOMAINS_ALFRED syncfolder -string "$Alfred_directory_in_Dropbox" ; success_or_not
  
  report_end_phase_standard
}
