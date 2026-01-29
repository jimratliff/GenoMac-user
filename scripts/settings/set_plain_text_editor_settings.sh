#!/usr/bin/env zsh

function set_plain_text_editor_settings() {

  report_start_phase_standard
  report_action_taken "Implement Plain Text Editor settings"

  local domain="com.sindresorhus.Plain-Text-Editor"

  report_adjust_setting "Editor » Text » Optimal line length: Turn OFF"
  defaults write "${domain}" optimalLineLength -bool false ; success_or_not

  report_adjust_setting "Editor » Interface » Content padding: Turn OFF"
  defaults write "${domain}" useContentPadding -bool false ; success_or_not

  report_adjust_setting "Editor » Stats » Line count: Turn ON"
  defaults write ${domain} enabledStats -array lineCount characterCount wordCount ; success_or_not
  
  report_end_phase_standard
}
