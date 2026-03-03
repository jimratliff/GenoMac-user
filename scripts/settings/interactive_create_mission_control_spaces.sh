#!/usr/bin/env zsh

function conditionally_create_additional_mission_control_spaces() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_MISSION_CONTROL_SPACES_CREATED" \
    interactive_create_mission_control_spaces \
    "Skipping creating Mission Control spaces, because it’s already been done"

  report_end_phase_standard
}

function interactive_create_mission_control_spaces() {
  report_start_phase_standard

  report "Let’s create come more Mission Control Spaces"
  report_action_taken "I’ve opened a Quick Look window with instructions"
  launch_app_and_prompt_user_to_act \
    --no-app \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Mission_Control_how_to_create_new_spaces.md" \
    "Follow the instructions in the Quick Look window to create 15 new Mission Control Spaces."

  report_success "Configuring user confirms they have completed creating Mission Control Spaces."
    
  report_end_phase_standard
}
