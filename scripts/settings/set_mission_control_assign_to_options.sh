#!/usr/bin/env zsh

function implement_mission_control_assign_to_options_for_selected_apps(){
  report_start_phase_standard

  set_bundle_id_to_AllSpaces "${BUNDLE_ID_1PASSWORD}"
  set_bundle_id_to_AllSpaces "${BUNDLE_ID_ACTIVITY_MONITOR}"
  set_bundle_id_to_AllSpaces "${BUNDLE_ID_CALENDAR}"
  set_bundle_id_to_AllSpaces "${BUNDLE_ID_CONTACTS}"
  set_bundle_id_to_AllSpaces "${BUNDLE_ID_NOTES}"
  set_bundle_id_to_AllSpaces "${BUNDLE_ID_REMINDERS}"
  set_bundle_id_to_AllSpaces "${BUNDLE_ID_STICKIES}"
  set_bundle_id_to_AllSpaces "${BUNDLE_ID_SYSTEM_SETTINGS}"
  set_bundle_id_to_AllSpaces "${BUNDLE_ID_TEXTEXPANDER}"

  killall Dock
  
  report_end_phase_standard
}

function set_bundle_id_to_AllSpaces(){
  # $1: Bundle ID of app to assign to AllSpaces
  #
  # Empirically, the required defaults write doesn’t seem to work properly when the bundle_ID is
  # not fully lowercase: It doesn’t result in the Assign-to option being set to "AllSpaces"
  # I don't want to change all my BUNDLE_ID_XXXX environment variables to be lowercase,
  # because I want to keep them faithful to what mdls tells me.
  # Thus, this function lowercases the BUNDLE_ID before using it.

  local bundle_id
  local lower_case_bundle_id
  bundle_id="$1"
  lower_case_bundle_id="${bundle_id:l}"

  report_adjust_setting "Setting app $bundle_id to show all of its windows on All Desktops"
  defaults write com.apple.spaces app-bindings -dict-add "${lower_case_bundle_id}" "AllSpaces" ; success_or_not
}
