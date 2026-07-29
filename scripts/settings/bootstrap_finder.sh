#!/usr/bin/env zsh

function bootstrap_finder_open_new_windows_to_home(){
  report_start_phase_standard
  report_adjust_setting "By default, new Finder window should open to user’s home directory"
  defaults write $DEFAULTS_DOMAINS_FINDER NewWindowTarget -string "PfHm" ; success_or_not
  report_end_phase_standard
}

function bootstrap_finder_toolbar() {
  # To be run only once per user to configure the initial toolbar.
  # See the related maintenance script: set_finder_settings.sh.

  report_start_phase_standard

  report_action_taken "Bootstrap-only configuration of Finder’s toolbar"

  local plist_path
  local toolbar_name="NSToolbar Configuration Browser"

  plist_path="$(legacy_plist_path_from_domain "${DEFAULTS_DOMAINS_FINDER}")"

  report_action_taken "Reconfigure Finder’s toolbar"

  report_adjust_setting "Show both icons and text in Finder’s toolbar"
  set_toolbar_to_show_both_icons_and_text "${plist_path}" "${toolbar_name}"

  # Other toolbar-item options:
  #   com.apple.finder.BACK — Back/Forward buttons
  #   com.apple.finder.SWCH — View mode switcher
  #   com.apple.finder.ARNG — Group/Sort options
  #   com.apple.finder.ACTN — Action menu
  #   com.apple.finder.SHAR — Share button
  #   com.apple.finder.EDIT — Edit tags
  #   com.apple.finder.SRCH — Search field
  #   NSToolbarFlexibleSpaceItem — Flexible space
  #   NSToolbarSpaceItem — Fixed space

  report_adjust_setting "Set Finder’s toolbar items"
  set_toolbar_items \
    "${plist_path}" \
    "${toolbar_name}" \
    "com.apple.finder.SRCH"

  # Finder automatically relaunches and reads the revised configuration.
  report_about_to_kill_app "Finder"
  killall Finder

  report_end_phase_standard
}
