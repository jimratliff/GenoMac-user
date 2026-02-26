#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_dock.sh" 
safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_finder.sh" 
safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_preview_app.sh" 
safe_source "${GMU_SETTINGS_SCRIPTS}/register_glance_as_quicklook.sh"

function conditionally_perform_initial_bootstrap_operations() {
  report_start_phase_standard

  # Glance: Register as a QuickLook plug
  run_if_user_has_not_done \
    "$PERM_GLANCE_HAS_BEEN_REGISTERED_AS_QUICKLOOK" \
    register_glance_as_quicklook \
    "Skipping registering Glance as QuickLook plugin, because this was done in the past"

  # Dock: Define initial configuration of persistent apps
  run_if_user_has_not_done \
    "$PERM_DOCK_BASE_PERSISTENT_APPS_HAVE_BEEN_SPECIFIED" \
    bootstrap_dock \
    "Skipping initial configuration of Dock, because this was done in the past"

  # Finder: Define initial toolbar
  run_if_user_has_not_done \
    "$PERM_FINDER_BASE_TOOLBAR_HAS_BEEN_SPECIFIED" \
    bootstrap_finder \
    "Skipping configuring Finder toolbar, because this was done in the past"

  # Preview.app: Define initial toolbar
  run_if_user_has_not_done \
    "$PERM_PREVIEW_BASE_TOOLBAR_HAS_BEEN_SPECIFIED" \
    bootstrap_preview_app \
    "Skipping configuring Preview toolbar, because this was done in the past"
  
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
