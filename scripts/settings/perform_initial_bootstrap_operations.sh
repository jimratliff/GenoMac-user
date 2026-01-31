#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_dock.sh" 
safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_finder.sh" 
safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_preview_app.sh" 
safe_source "${GMU_SETTINGS_SCRIPTS}/register_glance_as_quicklook.sh"

function conditionally_perform_initial_bootstrap_operations() {
  report_start_phase_standard

  run_if_user_has_not_done \
    --force-logout \
    "$PERM_BASIC_BOOTSTRAP_OPERATIONS_HAVE_BEEN_PERFORMED" \
    perform_initial_bootstrap_operations \
    "Skipping basic bootstrap operations, because they’ve already been performed"
  
  report_end_phase_standard
}

function perform_initial_bootstrap_operations() {
  report_start_phase_standard

  report_action_taken "Performing initial, basic bootstrapping steps"

  # Glance: Register as a QuickLook plug
  register_glance_as_quicklook
  
  # Dock: Define initial configuration of persistent apps
  bootstrap_dock
  
  # Finder: Define initial toolbar
  bootstrap_finder
  
  # Preview.app: Define initial toolbar
  bootstrap_preview_app

  report_end_phase_standard
}
