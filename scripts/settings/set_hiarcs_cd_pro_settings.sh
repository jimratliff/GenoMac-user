#!/usr/bin/env zsh

conditionally_configure_hiarcs_ce_pro() {
  report_start_phase_standard

  ############### BEGIN: TO BE REMOVED ###############
  # report_warning "The configuration of HIARCS Chess Explorer Pro hasn’t been implemented yet!"
  # report_end_phase_standard
  # return 0
  ############### END: TO BE REMOVED ###############

  if ! test_genomac_user_state "$SESH_HIARCS_CHESS_EXPLORER_PRO_USER_WANTS_IT"; then
    report_action_taken_to_log "Skipping HIARCS Chess Explorer Pro configuration, because this user doesn’t want it"
    report_end_phase_standard
    return 0
  fi
  
  run_if_user_has_not_done \
    "$PERM_HIARCS_CHESS_EXPLORER_PRO_HAS_ACTIVATED_LICENSE" \
    interactive_activate_license_hiarcs_ce_pro \
    "Skipping activating license for HIARCS Chess Explorer Pro because it’s been done in the past"
  
#   run_if_user_has_not_done \
#     "$PERM_HIARCS_CHESS_EXPLORER_PRO_HAS_BEEN_BOOTSTRAPPED" \
#     bootstrap_hiarcs_ce_pro \
#     "Skipping bootstrapping HIARCS Chess Explorer Pro because it’s been done in the past"

  configure_hiarcs_ce_pro_idempotent_settings
    
  report_end_phase_standard
}

function interactive_activate_license_hiarcs_ce_pro() {
  # Interactively guide user to activate license for HIARCS Chess Explorer Pro
  report_start_phase_standard
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/HIARCS_how_to_activate_license.md" \
    "$BUNDLE_ID_HIARCS_CE_PRO" \
    "Follow the instructions to activate the license for HIARCS Chess Explorer Pro"
  report_end_phase_standard
}

# function bootstrap_hiarcs_ce_pro() {
#   # Bootstrap HIARCS Chess Explorer Pro
#   report_start_phase_standard
# 
#   report_warning "NOT YET IMPLEMENTED: bootstrap_hiarcs_ce_pro()"
#   
#   report_end_phase_standard
# }

function configure_hiarcs_ce_pro_idempotent_settings() {
  # Configure HIARCS Chess Explorer Pro’s idempotent settings
  report_start_phase_standard

  report_action_taken "Implement HIARCS Chess Explorer Pro settings"

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_HIARCS_CE_PRO"

  local domain="$DEFAULTS_DOMAINS_HIARCS_CHESS_EXPLORER_PRO"

  report_adjust_setting "Hide toolbar"
  defaults write "$domain" "Geometry.toolbarEnabled" -bool false ; success_or_not
  
  report_adjust_setting "Always show tab bar"
  defaults write "$domain" "Geometry.showTabBar" -bool true ; success_or_not

  # ❌ WARNING: NOT WORKING
  report_adjust_setting "Board: visual mode: outline"
  defaults write "$domain" "Board.pieceEffect" -int 1 ; success_or_not
  
  report_adjust_setting "Board: Show frame"
  defaults write "$domain" "Board.showFrame" -bool true ; success_or_not
  
  report_adjust_setting "Board style: plain colors"
  defaults write "$domain" "Board.boardTheme" -string "@Invalid()" ; success_or_not
  
  report_adjust_setting "Board: Set color for light squares"
  defaults write "$domain" Board.lightColor -data "4056617269616e74280000004301c3bfc3bfc3a2c2a9c3a35fc38ac38a000029"
  
  report_adjust_setting "Board: Set color for dark squares"
  defaults write "$domain" Board.darkColor -data "4056617269616e74280000004301c3bfc3bf7542c28e775656000029"
  
  report_adjust_setting "Board: Do NOT show “best move”"
  defaults write "$domain" "Board.showBestMove" -bool false ; success_or_not
  
  report_adjust_setting "Board: DO show last move"
  defaults write "$domain" "Board.showLastMove" -bool true ; success_or_not
  
  report_adjust_setting "Board: NEVER autocomplete move"
  defaults write "$domain" "Board.guessMove" -int 0 ; success_or_not
  
  report_adjust_setting "Board: NEVER show “move quality” while dragging"
  defaults write "$domain" "Board.showMoveQuality" -int 0 ; success_or_not
  
  report_adjust_setting "Board: Show variation popup on right arrow (not on ⌘→)"
  defaults write "$domain" "Board.showVariations" -int 1 ; success_or_not
  
  report_adjust_setting "Game view: Use columns for main line"
  defaults write "$domain" "GameView.columnView" -bool true ; success_or_not

  invalidate_preferences_cache
  
  report_end_phase_standard
}
