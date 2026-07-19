#!/usr/bin/env zsh

function register_flux_markdown_as_quicklook() {

  # Flux-markdown needs to be launched once per user to register itself as a QuickLook plugin.
  # Presumably, this is only once forever.

  report_start_phase_standard
  report_action_taken "Register flux-markdown as a Quick Look plugin"

  launch_and_quit_app "${BUNDLE_ID_FLUXMARKDOWN}" ; success_or_not

  report_end_phase_standard
}
