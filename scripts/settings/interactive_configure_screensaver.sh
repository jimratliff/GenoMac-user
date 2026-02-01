#!/usr/bin/env zsh

function conditionally_interactive_configure_screensaver() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_SCREENSAVER_HAS_BEEN_CHOSEN_AND_CONFIGURED" \
    interactive_configure_screensaver \
    "Skipping configuring screen saver because it’s already been done"

  report_end_phase_standard
}

function interactive_configure_screensaver() {
  report_start_phase_standard

  report "Let’s implement the default custom screen saver: Matrix."
  report_action_taken "I’ve opened (a) the Wallpaper panel in System Settings and (b) a Quick Look window with instructions"
  open_wallpaper_panel
  launch_app_and_prompt_user_to_act \
    --no-app \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Screensaver_how_to_configure.md" \
    "Follow the instructions in the Quick Look window to choose your screen saver."

  report_success "Configuring user confirms they have completed choosing their screen saver."
    
  report_end_phase_standard
}
