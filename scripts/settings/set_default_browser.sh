#!/usr/bin/env zsh

function conditionally_set_default_browser() {
  # This operation is bootstrap only because it mysteriously is very slow to run, 
  # and is therefore too costly to perform every time the Hypervisor is run.
  report_start_phase_standard
  run_if_user_has_not_done "$PERM_DEFAULT_BROWSER_HAS_BEEN_SET" \
    set_default_browser \
    "Skipping setting default browser, because this was set in the past"
  report_end_phase_standard
}

function set_default_browser() {
  # Sets the user’s chosen browser as the default browser. (See "$chosen_browser_id".)
  # Specify the browser’s Bundle Identifier (CFBundleIdentifier) as the argument.
  #
  # Relies on the `default-browser` CLI tool by macadmins, available on GitHub but not
  # (as of 1/4/2026) from Homebrew. It is installed by GenoMac-system.
  # https://github.com/macadmins/default-browser
  #
  # To determine the bundle ID of an app:
  #   mdls -name kMDItemCFBundleIdentifier -r /Applications/AppName.app
  #     or
  #   osascript -e 'id of app "App Name"'
  #
  # For unknown reasons, this step can take a LONG time to execute.
  # Here is typical output:
  #   🪚 Set default browser to org.mozilla.firefox
  #   Adding handler: {public.url map[LSHandlerRoleViewer:-] org.mozilla.firefox  }
  #   Adding handler: {public.xhtml map[LSHandlerRoleAll:-]  org.mozilla.firefox }
  #   Adding handler: {public.html map[LSHandlerRoleAll:-]  org.mozilla.firefox }
  #   Adding handler: { map[LSHandlerRoleAll:-]  org.mozilla.firefox https}
  #   Adding handler: { map[LSHandlerRoleAll:-]  org.mozilla.firefox http}
  
  report_start_phase_standard
  
  # Path where the default-browser app is installed by its package installer
  local path_to_installed_default_browser_utility="/opt/macadmins/bin/default-browser"
  
  # Un-comment the line corresponding to the desired default browser
  # local chosen_browser_id="$BUNDLE_ID_BRAVE"
  # local chosen_browser_id="$BUNDLE_ID_FIREFOX"
  # local chosen_browser_id="$BUNDLE_ID_GOOGLE_CHROME"
  # local chosen_browser_id="$BUNDLE_ID_HELIUM"
  # local chosen_browser_id="$BUNDLE_ID_SAFARI"
  local chosen_browser_id="$BUNDLE_ID_WATERFOX"
  
  report_action_taken "Set default browser to $chosen_browser_id"
  "$path_to_installed_default_browser_utility" --identifier "$chosen_browser_id" ; success_or_not
  
  report_end_phase_standard

}
