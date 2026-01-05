#!/bin/zsh

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
  
  local browser_id_chrome="com.google.chrome"
  local browser_id_safari="com.apple.safari"
  local browser_id_firefox="org.mozilla.firefox"
  local browser_id_brave="com.brave.Browser"
  
  # Un-comment the line corresponding to the desired default browser
  local chosen_browser_id="$browser_id_firefox"
  # local chosen_browser_id="$browser_id_safari"
  # local chosen_browser_id="$browser_id_brave"
  # local chosen_browser_id="$browser_id_chrome"
  
  report_action_taken "Set default browser to $chosen_browser_id"
  "$path_to_installed_default_browser_utility" --identifier "$chosen_browser_id" ; success_or_not
  
  report_end_phase_standard

}
