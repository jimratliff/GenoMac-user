#!/bin/zsh

function register_glance_as_quicklook() {

  # Glance needs to be launched once per user to register itself as a QuickLook plugin.
  # Presumably, this is only once forever. I assume that merely updating the version of
  # Glance doesn’t necessitate re-registration.

  report_start_phase_standard
  report_action_taken "Register Glance as a Quick Look plugin"

  local glance_bundle_id="com.chamburr.Glance"
  launch_and_quit_app "${glance_bundle_id}" ; success_or_not

  report_end_phase_standard
}
