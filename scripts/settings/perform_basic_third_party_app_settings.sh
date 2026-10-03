#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/set_bbedit_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_chatgpt_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_claude_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_graphicconverter_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_iterm_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_omnioutliner_settings.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_plain_text_editor_settings.sh"

############################## BEGIN SCRIPT PROPER ##############################

function conditionally_perform_basic_third_party_app_settings() {
  report_start_phase_standard

  run_if_user_has_not_done \
    --force-logout \
    "$SESH_BASIC_THIRD_PARTY_APP_SETTINGS_HAVE_BEEN_IMPLEMENTED" \
    perform_basic_third_party_app_settings \
    "Skipping basic third-party app user-level settings, because they’ve already been set this session"
  
  report_end_phase_standard
}

function perform_basic_third_party_app_settings() {
  report_start_phase_standard
  report_action_taken "Begin settings for certain third-party applications"
  
  # BBEdit
  set_bbedit_settings                  # scripts/settings/set_bbedit_settings.sh
  
  # ChatGPT
  set_chatgpt_settings                 # scripts/settings/set_chatgpt_settings.sh
  
  # Claude
  set_claude_settings                  # scripts/settings/set_claude_settings.sh
  
  # GraphicConverter
  set_GraphicConverter_settings        # scripts/settings/set_graphicconverter_settings.sh
  
  # iTerm2
  set_iterm_settings                   # scripts/settings/set_iterm_settings.sh
  
  # OmniOutliner
  set_omnioutliner_settings            # scripts/settings/set_omnioutliner_settings.sh

  # Plain Text Editor
  set_plain_text_editor_settings       # scripts/settings/set_plain_text_editor_settings.sh

  # Witch
  set_witch_settings                   # scripts/settings/set_witch_settings.sh
  
  report_end_phase_standard
}
