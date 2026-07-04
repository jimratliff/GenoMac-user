#!/usr/bin/env zsh

function set_default_browser() {
  # Sets the user’s chosen browser as the default browser. (See "$chosen_browser_id".)
  # Specify the browser’s Bundle Identifier (CFBundleIdentifier) as the argument.
  #
  # WARNING: The latest published release (v1.0.18) as of 6/29/2026 is NOT compatible
  #          with home directories that are not on the startup volume. (Thus, it is not
  #          compatible with almost every user of Project GenoMac.) See Issue #23,
  #          “default-browser assumes home directory is /Users/<username>, which fails
  #          for relocated macOS home directories #23”
  #          https://github.com/macadmins/default-browser/issues/23
  #
  #          I have forked this repo and applied a conjectured fix. This has evolved to
  #          a PR: Use actual home directory for LaunchServices plist#24
  #          https://github.com/macadmins/default-browser/pull/24
  #
  #          As of 7/3/2026, the developer is actively involved in the PR.
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

  if is_default_browser_utility_unavailable_for_this_user; then
    report_fail "PROGRAMMER ERROR: default-browser CLI utility isn’t compatible with user directories that aren’t on the startup volume${NEWLINE}This point shouldn’t be reached."
    return 1
  fi
  
  report_action_taken "Set default browser to $chosen_browser_id"
  "$path_to_installed_default_browser_utility" --identifier "$chosen_browser_id" ; success_or_not
  
  report_end_phase_standard

}
