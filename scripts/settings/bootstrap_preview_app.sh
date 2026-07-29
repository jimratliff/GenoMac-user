#!/usr/bin/env zsh

function bootstrap_preview_app() {
  # To be run only once per user to configure the initial toolbar for Preview.app.
  # See the related maintenance script: set_preview_settings.sh.

  report_start_phase_standard
  
  report_action_taken "Bootstrap-only configuration of Preview.app’s toolbar"

  local plist_path
  local toolbar_name="NSToolbar Configuration CommonToolbar_v5.1"

  plist_path="$(sandboxed_plist_path_from_domain "${DEFAULTS_DOMAINS_PREVIEW}")"

  report_action_taken "Launching and quitting Preview to prepare its preferences"
  launch_and_quit_app "${BUNDLE_ID_PREVIEW}"

  report_adjust_setting "Show both icons and text in Preview’s toolbar"
  set_toolbar_to_show_both_icons_and_text "${plist_path}" "${toolbar_name}"

  report_adjust_setting "Set Preview’s toolbar items"
  set_toolbar_items \
    "${plist_path}" \
    "${toolbar_name}" \
    "goto_page" \
    "form_filling" \
    "scale" \
    "search"

  report_end_phase_standard
}
