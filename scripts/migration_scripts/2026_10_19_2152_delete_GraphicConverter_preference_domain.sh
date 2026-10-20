#!/usr/bin/env zsh

function 2026_10_19_2152_delete_GraphicConverter_preference_domain() {
  # Template for a Zsh function in Project GenoMac
  report_start_phase_standard

  report_action_taken "Migration: Delete GraphicsConverter 12 preference domain for clean start"
  
  # HINT: DEFAULTS_DOMAINS_GRAPHIC_CONVERTER_12="com.lemkesoft.graphicconverter12"
  local domain="$DEFAULTS_DOMAINS_GRAPHIC_CONVERTER_12"

  defaults delete ${domain} || true

  report_end_phase_standard
}
