#!/usr/bin/env zsh

function register_glance_as_quicklook() {

  # Glance needs to be launched once per user to register itself as a QuickLook plugin.
  # Presumably, this is only once forever. I assume that merely updating the version of
  # Glance doesn’t necessitate re-registration.

  report_start_phase_standard
  report_action_taken "Register Glance as a Quick Look plugin"

  launch_and_quit_app "${BUNDLE_ID_GLANCE}" ; success_or_not

  report_end_phase_standard
}
