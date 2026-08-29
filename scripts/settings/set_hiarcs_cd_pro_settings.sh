#!/usr/bin/env zsh

CHESS_ENGINE_STOCKFISH_BINARY_PATH="/opt/homebrew/Cellar/stockfish/18/bin/stockfish"
CHESS_ENGINE_LC0_BINARY_PATH="/opt/homebrew/Cellar/lc0/0.32.1/bin/lc0"
CHESS_ENGINE_NUMBER_STOCKFISH="4"
CHESS_ENGINE_NUMBER_LC0="5"

conditionally_configure_hiarcs_ce_pro() {
  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_HIARCS_CHESS_EXPLORER_PRO_USER_WANTS_IT"; then
    report_action_taken_to_log "Skipping HIARCS Chess Explorer Pro configuration, because this user doesn’t want it"
    report_end_phase_standard
    return 0
  fi
  
  run_if_user_has_not_done \
    "$PERM_HIARCS_CHESS_EXPLORER_PRO_HAS_ACTIVATED_LICENSE" \
    interactive_activate_license_hiarcs_ce_pro \
    "Skipping activating license for HIARCS Chess Explorer Pro because it’s been done in the past"
  
  run_if_user_has_not_done \
    "$PERM_HIARCS_CHESS_EXPLORER_PRO_ENGINES_HAVE_BEEN_BOOTSTRAPPED" \
    bootstrap_engines_hiarcs_ce_pro \
    "Skipping bootstrapping additional chess engines for HIARCS Chess Explorer Pro because it’s been done in the past"

  configure_hiarcs_ce_pro_idempotent_settings
    
  report_end_phase_standard
}

function bootstrap_engines_hiarcs_ce_pro() {
  # Add additional chess engines to HIARCS Chess Explorer Pro as a bootstrap step.
  report_start_phase_standard

  report_action_taken "Boostrap additional chess engines into HIARCS Chess Explorer Pro"

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_HIARCS_CE_PRO"

  local domain="$DEFAULTS_DOMAINS_HIARCS_CHESS_EXPLORER_PRO"
  local plist_path

  plist_path="$(legacy_plist_path_from_domain $domain)"
  ensure_plist_path_exists "${plist_path}"

  report_adjust_setting "Add Stockfish"
  defaults write $domain "Engines.$CHESS_ENGINE_NUMBER_STOCKFISH.Command" -string "$CHESS_ENGINE_STOCKFISH_BINARY_PATH"
  defaults write $domain "Engines.$CHESS_ENGINE_NUMBER_STOCKFISH.EloLimit" -string "1320-3190"
  defaults write $domain "Engines.$CHESS_ENGINE_NUMBER_STOCKFISH.Name" -string "Stockfish 18"
  defaults write $domain "Engines.$CHESS_ENGINE_NUMBER_STOCKFISH.OriginalName" -string "Stockfish 18"
  
  report_adjust_setting "Add Lc0"
  defaults write $domain "Engines.$CHESS_ENGINE_NUMBER_LC0.Command" -string "$CHESS_ENGINE_LC0_BINARY_PATH"
  defaults write $domain "Engines.$CHESS_ENGINE_NUMBER_LC0.Name" -string "Lc0 v0.32.1"
  defaults write $domain "Engines.$CHESS_ENGINE_NUMBER_LC0.OriginalName" -string "Lc0 v0.32.1+git.dirty"
  
  
  report_end_phase_standard
}

function HIARCS_engine_helper() {
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard
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

function configure_hiarcs_ce_pro_idempotent_settings() {
  # Configure HIARCS Chess Explorer Pro’s idempotent settings
  report_start_phase_standard

  report_action_taken "Implement HIARCS Chess Explorer Pro settings"

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_HIARCS_CE_PRO"

  local domain="$DEFAULTS_DOMAINS_HIARCS_CHESS_EXPLORER_PRO"
  local plist_path

  plist_path="$(legacy_plist_path_from_domain $domain)"
  ensure_plist_path_exists "${plist_path}"

  report_adjust_setting "Hide toolbar"
  defaults write "$domain" "Geometry.toolbarEnabled" -bool false ; success_or_not
  
  report_adjust_setting "Always show tab bar"
  defaults write "$domain" "Geometry.showTabBar" -bool true ; success_or_not

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
  
  report_adjust_setting "Engine: Autostart analysis: NEVER"
  defaults write "$domain" "Analysis.autostart" -int 0 ; success_or_not
  
  report_adjust_setting "Advanced: Clipboard includes coordinates"
  defaults write "$domain" "Copy.imageCoordinates" -bool true ; success_or_not

  invalidate_preferences_cache
  
  report_end_phase_standard
}

function hiarcs_chess_explorer_pro_utility_report_current_square_colors_for_defaults_write_commands() {
  # Utility for HIARCS Chess Explorer Pro, to be run OUTSIDE OF HYPERVISOR, that reports the
  # serialized colors of the light and dark squares of the board as currently configured in HIARCS Chess
  # Explorer Pro for use in `defaults write` commands to implement those choices programmatically
  # using function configure_hiarcs_ce_pro_idempotent_settings()
  # 
  # Usage:
  #   - Launch HIARCS Chess Explorer Pro
  #     - Preferences (⌘,) » Board » Colors (assuming “Board style” is “[plain colors]”
  #       - Light squares: set to desired color
  #       - Dark squares: set to desired color
  #     - Quit HIARCS Chess Explorer Pro
  #   - In a terminal
  #     - `cd ~/.genomac-user`
  #     - `just HIARCS_report_colors`
  #     - This `just` command runs this function.
  #     - Two hex strings will be output, for the light-squares color and the dark-squares color, respectively.
  #     - These hex strings should replace those in:
  #         report_adjust_setting "Board: Set color for light squares"
  #         defaults write "$domain" Board.lightColor -data "4056617269616e74280000004301c3bfc3bfc3a2c2a9c3a35fc38ac38a000029"
  #         report_adjust_setting "Board: Set color for dark squares"
  #         defaults write "$domain" Board.darkColor -data "4056617269616e74280000004301c3bfc3bf7542c28e775656000029"
  #     
  report_start_phase_standard
  local light_hex
  local dark_hex
  
  defaults export com.hiarcs.ChessExplorerPro - |
    python3 -c '
import plistlib
import sys

preferences = plistlib.loads(sys.stdin.buffer.read())

for label, key in (
    ("Light squares", "Board.lightColor"),
    ("Dark squares", "Board.darkColor"),
):
    value = preferences.get(key)

    if not isinstance(value, bytes):
        raise SystemExit(
            f"{key!r} is missing or is not stored as binary data"
        )

    print(f"{label}: -data \"{value.hex()}\"")
'

  report_end_phase_standard
  
}
