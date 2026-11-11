#!/usr/bin/env zsh

function delete_GraphicConverter_preference_domain() {
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard

  report_action_taken "Migration: Delete GraphicsConverter 12 preference domain for clean start"

  # HINT: DEFAULTS_DOMAINS_GRAPHIC_CONVERTER_12="com.lemkesoft.graphicconverter12"
  local domain="$DEFAULTS_DOMAINS_GRAPHIC_CONVERTER_12"

  defaults delete ${domain} || true

  report_end_phase_standard
}

function fetch_repo_tags() {
  # Fetches the repo’s tags so that the compliance state can reference a base versioni
  # and measure the current commit numerically with reference to that base version.
  report_start_phase_standard

  git fetch --tags origin

  report_end_phase_standard
}
