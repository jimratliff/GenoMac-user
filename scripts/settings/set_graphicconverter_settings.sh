#!/usr/bin/env zsh

function set_GraphicConverter_settings() {

  report_start_phase_standard
  report_action_taken "Implement GraphicConverter settings"
  
  local domain="DEFAULTS_DOMAINS_GRAPHIC_CONVERTER_12"

  # Ensure preference domain exists
  launch_and_quit_app "$BUNDLE_ID_GRAPHIC_CONVERTER_12"

  report_adjust_setting "Set: Don’t show splash dialog at app launch"
  defaults write ${domain} GCShowFirstStepsDialogNextGen -bool false ; success_or_not

  report_adjust_setting "Set: Slide show: Don’t darken all screens"
  defaults write ${domain} GCSlideShowDarkenAllScreens -bool false ; success_or_not

  report_adjust_setting "Set: Slide show: Length of filename text before truncation"
  defaults write ${domain} GCSlideShowShortenFilenameLength -integer 500 ; success_or_not

  report_adjust_setting "Set: Slide show: Show filename"
  defaults write ${domain} GCSlideShowShowsFileName -bool true ; success_or_not

  report_adjust_setting "Set: Slide show: Show details about file"
  defaults write ${domain} GCSlideShowShowsDetails -bool true ; success_or_not

  report_adjust_setting "Set: Slide show: Show path"
  defaults write ${domain} GCSlideShowShowsPath -bool true ; success_or_not

  report_adjust_setting "Set: Slide show: Show extension"
  defaults write ${domain} GCSlideShowShowsExtension -bool true ; success_or_not

  report_adjust_setting "Set: Slide show: Show text in normal mode (not color diff) against its background"
  defaults write ${domain} GCSlideshowTextDisplayMode -integer 0 ; success_or_not

  report_adjust_setting "Set: Slide show: Transitions: Use fade"
  defaults write ${domain} GCSlideshowAnimation0 -bool true ; success_or_not

  # Warning: This might not work, because I’m not also creating GCSlideShowSelectedTransitions
  report_adjust_setting "Set: Slide show: Transitions: Turn off all other transitions"
  defaults write ${domain} GCSlideshowAnimation1 -bool false ; success_or_not
  defaults write ${domain} GCSlideshowAnimation2 -bool false ; success_or_not
  defaults write ${domain} GCSlideshowAnimation3 -bool false ; success_or_not
  
  report_end_phase_standard

}
