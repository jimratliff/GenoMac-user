#!/usr/bin/env zs

function conditionally_configure_alfred() {
  report_start_phase_standard
  
  run_if_user_has_not_done "$PERM_ALFRED_HAS_BEEN_CONFIGURED" \
    interactive_configure_alfred \
    "Skipping configuring Alfred, because it’s already been configured"
  
  report_end_phase_standard
}

function interactive_configure_alfred() {
  # Bootstrap Alfred.app for (a) activation of Powerpack and (b) syncing preferences.
  #
  # Because preference syncing relies on the existence of a directory in the user’s Dropbox directory,
  # this bootstrapping step must wait until Dropbox is configured for the user. (It is up
  # to the hypervisor to perform this check before calling this function.)
  #
  # Because semi-automated activation of the Powerpack requires a custom Keyboard Maestro macro,
  # this bootstrapping step must wait until Keyboard Maestro is configured for the user. (This ordering
  # requiring must be enforced by the design of the Hypervisor.)
  
  report_start_phase_standard

  report "Time to configure Alfred! I’ll launch it, and open a window with instructions for next steps"

  # DEPRECATED: See function enable_alfred_preferences_syncing() below for more details
  #
  # Specify directory where synced Alfred preferences reside
  # quit_app_by_bundle_id_if_running "$BUNDLE_ID_ALFRED" ; success_or_not
  # enable_alfred_preferences_syncing
  # quit_app_by_bundle_id_if_running "$BUNDLE_ID_ALFRED" ; success_or_not
  # sleep 2

  # Specify folder that contains the `Alfred_5_preferences` directory that contains the Alfred preferences file
  # By opening this container folder, the executing user can drag the `Alfred_5_preferences` folder icon
  # into the Open-file dialog presented under Advanced » Syncing » Set preferences folder…
  local container_directory="$GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY/Alfred_preferences"
  launch_app_and_prompt_user_to_act \
    --show-doc "${GENOMAC_USER_DOCS_TO_DISPLAY_DIRECTORY}/Alfred_how_to_configure.md" \
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

  # Hint: GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY="${GENOMAC_USER_DROPBOX_DIRECTORY}/Preferences_common"
  local Alfred_directory_in_Dropbox="$GENOMAC_USER_SHARED_PREFERENCES_DIRECTORY/Alfred_preferences/Alfred_5_preferences"
  
  report_adjust_setting "Set: Path to Alfred preferences directory in Dropbox"
  defaults write $DEFAULTS_DOMAINS_ALFRED syncfolder -string "$Alfred_directory_in_Dropbox" ; success_or_not
  
  report_end_phase_standard
}
