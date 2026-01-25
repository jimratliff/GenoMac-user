#!/usr/bin/env zsh

function set_default_apps_to_open() {
  # Sets default app(s) for certain document type(s)
  #
  # Uses Uniform Type Identifiers (UTIs) to refer to document types.
  # Uses bundle IDs to refer to apps.
  #
  # To determine the UTI of…
  #   a particular file:
  #   mdls -name kMDItemContentType -r /path/to/file
  #
  #   a filename extension (using an example file):
  #   mdls -name kMDItemContentType -r example.md
  #
  # To determine the bundle ID of an app:
  #   mdls -name kMDItemCFBundleIdentifier -r /Applications/AppName.app
  #     or
  #   osascript -e 'id of app "App Name"'
  
  report_start_phase_standard
  report_action_taken "Assign default app(s) for document type(s)"
  
  local uti_plain_text=public.plain-text
  local uti_markdown=net.daringfireball.markdown
  local uti_shell_script=public.shell-script
  local uti_plist=com.apple.property-list
  local uti_xml=public.xml
  local uti_applescript=com.apple.applescript.text
  
  report_adjust_setting "Set plain-text files to open with BBEdit"
  printf "\n"
  utiluti type set $uti_plain_text     $BUNDLE_ID_BBEDIT ; success_or_not
  
  report_adjust_setting "Set Markdown files to open with BBEdit"
  printf "\n"
  utiluti type set $uti_markdown       $BUNDLE_ID_BBEDIT ; success_or_not
  
  report_adjust_setting "Set .plist files to open with BBEdit"
  printf "\n"
  utiluti type set $uti_plist          $BUNDLE_ID_BBEDIT ; success_or_not
  
  report_adjust_setting "Set shell scripts to open with BBEdit"
  printf "\n"
  utiluti type set $uti_shell_script   $BUNDLE_ID_BBEDIT ; success_or_not
  
  report_adjust_setting "Set XML files to open with BBEdit"
  printf "\n"
  utiluti type set $uti_xml            $BUNDLE_ID_BBEDIT ; success_or_not
  
  report_adjust_setting "Set AppleScript files to open with BBEdit"
  printf "\n"
  utiluti type set $uti_applescript    $BUNDLE_ID_BBEDIT ; success_or_not
  
  report_end_phase_standard

}
