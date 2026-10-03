#!/usr/bin/env zsh

function set_chatgpt_settings() {

  report_start_phase_standard
  report_action_taken "Implement ChatGPT settings"
  
  local domain="com.openai.chat"
  local domain2="ChatGPTHelper"
  
  report_adjust_setting "Set: Never automatically reset conversations"
  defaults write ${domain} launcherChatResetDuration -string '{"never":{}}' ; success_or_not
  
  report_adjust_setting "Set: Never show in menubar"
  defaults write ${domain} desktopMenuBarBehavior -string '{"never":{}}' ; success_or_not
  
  report_adjust_setting "Set: Do not suggest trending searches"
  defaults write ${domain} trendingSuggestionsEnabled -bool false ; success_or_not
  
  report_adjust_setting "Remove hotkey for chat bar in domain: ($domain)"
  defaults write ${domain} KeyboardShortcuts_toggleLauncher -string '' ; success_or_not
  report_adjust_setting "Remove hotkey for chat bar in domain: ($domain2)"
  defaults write ${domain2} KeyboardShortcuts_toggleLauncher -string '' ; success_or_not
  
  report_adjust_setting "Skip phone verification (These are not the droids…)"
  defaults write ${domain} canSkipPhoneVerification -bool true ; success_or_not

  # Invalidate preferences cache to ensure our changes won’t be overwritten by cached values
  invalidate_preferences_cache
  
  report_end_phase_standard

}
