#!/bin/zsh

function set_terminal_settings() {

  report_start_phase_standard
  
  local domain="com.apple.Terminal"
  
  report_action_taken "Give the Terminal a teeny bit of style, even though we will soon abandon it"
  report_adjust_setting "Terminal: default for new windows: “Man Page”"
  defaults write "${domain}" "Default Window Settings" -string "Man Page" ; success_or_not
  report_adjust_setting "Terminal: default for starting windows: “Man Page”"
  defaults write "${domain}" "Startup Window Settings" -string "Man Page" ; success_or_not
  
  report_end_phase_standard

}
