#!/usr/bin/env zsh

function implement_mission_control_assign_to_options_for_selected_apps(){
  report_start_phase_standard

  local domain="com.apple.spaces"

  #  defaults write "${domain}" app-bindings -dict-add "${BUNDLE_ID_1PASSWORD}" "AllSpaces"
  #  defaults write "${domain}" app-bindings -dict-add "${BUNDLE_ID_ACTIVITY_MONITOR}" "AllSpaces"
  #  defaults write "${domain}" app-bindings -dict-add "${BUNDLE_ID_CALENDAR}" "AllSpaces"
  #  defaults write "${domain}" app-bindings -dict-add "${BUNDLE_ID_CONTACTS}" "AllSpaces"
  #  defaults write "${domain}" app-bindings -dict-add "${BUNDLE_ID_NOTES}" "AllSpaces"
  #  defaults write "${domain}" app-bindings -dict-add "${BUNDLE_ID_REMINDERS}" "AllSpaces"
  #  defaults write "${domain}" app-bindings -dict-add "${BUNDLE_ID_STICKIES}" "AllSpaces"
  #  defaults write "${domain}" app-bindings -dict-add "${BUNDLE_ID_SYSTEM_SETTINGS}" "AllSpaces"
  #  defaults write "${domain}" app-bindings -dict-add "${BUNDLE_ID_TEXTEXPANDER}" "AllSpaces"

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
  lower_case_bundle_id="${bundle_id,,}"

  report_adjust_setting "Setting app $bundle_id to show all of its windows on All Desktops"
  defaults write com.apple.spaces app-bindings -dict-add "${lower_case_bundle_id}" "AllSpaces"
}

# function conditionally_assign_apps_a_mission_control_assign_to_option() {
#   report_start_phase_standard
# 
#   if ! test_genomac_user_state "$PERM_MISSION_CONTROL_SPACES_CREATED"; then
#     report_action_taken "Skipping assigning apps a Mission Control assign-to option, because${NEWLINE}additional Spaces haven’t been created yet."
#     return 0
#   fi
# 
#   run_if_user_has_not_done \
#     "$PERM_MISSION_CONTROL_ASSIGN_TO_OPTIONS_HAVE_BEEN_CONFIGURED" \
#     interactive_assign_apps_a_mission_control_assign_to_option \
#     "Skipping assigning apps a Mission Control assign-to option, because it’s already been done"
# 
#   report_end_phase_standard
# }

# function interactive_assign_apps_a_mission_control_assign_to_option() {
#   report_start_phase_standard
# 
#   report "Let’s specify which apps should open in all Spaces"
#   report_action_taken "I’ve opened (a) the Wallpaper panel in System Settings and (b) a Quick Look window with instructions"
#   launch_app_and_prompt_user_to_act \
#     --no-app \
#     --show-doc "${GMU_DOCS_TO_DISPLAY}/Mission_Control_how_to_create_new_spaces.md" \
#     "Follow the instructions in the Quick Look window to create 15 new Mission Control Spaces."
# 
#   report_success "Configuring user confirms they have completed creating Mission Control Spaces."
#     
#   report_end_phase_standard
# }
