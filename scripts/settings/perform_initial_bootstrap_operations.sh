#!/usr/bin/env zsh

safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_dock.sh" 
safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_finder.sh" 
safe_source "${GMU_SETTINGS_SCRIPTS}/bootstrap_preview_app.sh" 
safe_source "${GMU_SETTINGS_SCRIPTS}/register_glance_as_quicklook.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_default_apps_to_open.sh"
safe_source "${GMU_SETTINGS_SCRIPTS}/set_default_browser.sh"

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

  # Dock/Spaces: Assign apps to open in AllSpaces
  run_if_user_has_not_done \
    "$PERM_MISSION_CONTROL_ASSIGN_TO_OPTIONS_HAVE_BEEN_CONFIGURED" \
    implement_mission_control_assign_to_options_for_selected_apps \
    "Skipping assigning apps a Mission Control assign-to option, because it’s already been done"

  # Finder: Define initial toolbar and default folder for new windows
  run_if_user_has_not_done \
    "$PERM_FINDER_HAS_BEEN_BOOTSTRAPPED" \
    bootstrap_finder \
    "Skipping configuring Finder toolbar, because this was done in the past"

  # Preview.app: Define initial toolbar
  run_if_user_has_not_done \
    "$PERM_PREVIEW_BASE_TOOLBAR_HAS_BEEN_SPECIFIED" \
    bootstrap_preview_app \
    "Skipping configuring Preview toolbar, because this was done in the past"

  # Set default browser
  # This operation is bootstrap only because mystertiously it takes a long time to exectute,
  # and is therefore too costly to perform every time the Hypervisor is run.
  run_if_user_has_not_done "$PERM_DEFAULT_BROWSER_HAS_BEEN_SET" \
    set_default_browser \
    "Skipping setting default browser, because this was set in the past"

  # Set default apps to open certain types of documents
  # This operation is bootstrap only because it generates dialog boxes the user must respond
  # to, and is therefore too costly to perform every time the Hypervisor is run.
  run_if_user_has_not_done "$PERM_DEFAULT_APPS_TO_OPEN_CERTAIN_TYPES_OF_DOCS_HAVE_BEEN_SET" \
    set_default_apps_to_open_certain_types_of_docs \
    "Skipping setting default apps to open certain types of docs, because that was set in the past"
  
  report_end_phase_standard
}
