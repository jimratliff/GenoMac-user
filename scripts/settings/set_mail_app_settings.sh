#!/usr/bin/env zsh

# NOTE: The email accounts for Mail.app are established throught the System Settings » Internet Account interface,
#       NOT through the Mail.app Settings » Accounts interface.
#
# Currently, it is assumed that:
# - Every user of Mail.app will have at least one Internet Account
#   - This is enforced by every user with user attribute USER_ATTRIBUTE_EMAILER is also assigned user attribute
#     USER_ATTRIBUTE_INTERNET_ACCOUNTS
# - A user that has an Internet Account need not want Mail.app

function conditionally_configure_internet_accounts_and_mail_app() {
  report_start_phase_standard

  conditionally_configure_internet_accounts

  conditionally_configure_mail_app

  report_end_phase_standard
}

function conditionally_configure_internet_accounts() {
  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_INTERNET_ACCOUNTS_USER_WANTS_IT"; then
    report_action_taken_to_log "Skipping configuring Internet Accounts, because this user doesn’t want these"
    report_end_phase_standard
    return 0
  fi

  run_if_user_has_not_done \
    "$PERM_INTERNET_ACCOUNTS_HAVE_BEEN_CONFIGURED" \
    interactive_configure_internet_accounts \
    "Skipping interactively configuring internet accounts because it’s been done in the past"

  report_end_phase_standard
}

function conditionally_configure_mail_app() {
  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_APPLE_MAIL_APP_USER_WANTS_IT"; then
    report_action_taken_to_log "Skipping configuring Mail.app, because this user doesn’t want it"
    report_end_phase_standard
    return 0
  fi

  run_if_user_has_not_done \
    "$PERM_APPLE_MAIL_APP_TOOLBAR_HAS_BEEN_BOOTSTRAPPED" \
    bootstrap_toolbars_for_mail_app \
    "Skipping bootstrapping Mail.app’s toolbar because it’s been done in the past"

  configure_mail_app_idempotent_settings

  report_end_phase_standard
}

function interactive_configure_internet_accounts() {
  # Interactively configure at least one internet account.
  #
  # - Looks for an optional user-specific Markdown file in $USER_SPECIFIC_META_DIRECTORY (e.g., ~/Dropbox/Prefs/Meta)
  #   to be displayed via QuickLook to guide the user through interactively configuring
  #   internet accounts.
  # - If this file is not present, an alternative, default document is displayed instead.
  #
  
  report_start_phase_standard

  local default_markdown_page_file
  local markdown_file_to_display
  local user_specific_markdown_page_file

  default_markdown_page_file="${GMU_DOCS_TO_DISPLAY}/${INTERNET_ACCOUNTS_MARKDOWN_PAGE_FILENAME}"
  user_specific_markdown_page_file="${USER_SPECIFIC_INTERNET_ACCOUNTS_SPECIFICATIONS_FILE}"

  local REPLY
  check_file_exists_and_is_readable "$user_specific_markdown_page_file"
  if (( REPLY )); then
    markdown_file_to_display="$user_specific_markdown_page_file"
  else
    markdown_file_to_display="$default_markdown_page_file"
  fi

  report "Time to configure at least one internet account!${NEWLINE}I’ll launch System Settings » Internet Accounts with instructions for next steps"
  launch_app_and_prompt_user_to_act \
    --no-app \
    --show-doc "$markdown_file_to_display" \
    --open "$SYSTEM_SETTINGS_INTERNET_ACCOUNTS_URL" \
    "Follow the instructions in the Quick Look window to configure Internet Accounts"
  
  report_end_phase_standard
}

function configure_mail_app_idempotent_settings() {
  # Configure Mail.app idempotent settings.
  report_start_phase_standard

  bomb_if_mail_app_plist_does_not_exist

  report_action_taken "Configure Mail.app"

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_MAIL_APP"

  # Settings » General » New messages notifications
  report_adjust_setting "Provide new-message notification for new messages in *all* mailboxes, not just Inbox"
  defaults write "$DEFAULTS_DOMAINS_MAIL_APP" MailUserNotificationScope -int 5
  success_or_not

  # Settings » Viewing » List preview
  report_adjust_setting "Provide 3 lines of message summary"
  defaults write "$DEFAULTS_DOMAINS_MAIL_APP" NumberOfSnippetLines -int 3
  success_or_not

  report_end_phase_standard
}

function bootstrap_toolbars_for_mail_app() {
  # Bootstrap the toolbars for main-window and single-message-viewer windows.
  report_start_phase_standard

  local mail_preferences_plist
  mail_preferences_plist="$(mail_app_plist_path)"

  bomb_if_mail_app_plist_does_not_exist

  quit_app_by_bundle_id_if_running \
    "${BUNDLE_ID_MAIL_APP}"

  ############### Main window

  set_toolbar_to_show_both_icons_and_text \
    "${mail_preferences_plist}" \
    "NSToolbar Configuration MainWindow"

  set_toolbar_items \
    "${mail_preferences_plist}" \
    "NSToolbar Configuration MainWindow" \
    "NSToolbarFlexibleSpaceItem" \
    "NSToolbarToggleSidebarItem" \
    "NSToolbarSidebarTrackingSeparatorItemIdentifier" \
    "toggleMessageListFilter:" \
    "messageListViewOptionsFromToolbar:" \
    "SeparatorToolbarItem" \
    "NSToolbarFlexibleSpaceItem" \
    "toggleThreadedMode:" \
    "toggleViewRelatedMessages:" \
    "toggleAllHeaders:" \
    "NSToolbarFlexibleSpaceItem" \
    "moveMessagesFromToolbar:" \
    "NSToolbarFlexibleSpaceItem" \
    "Search"

  ############### Single-message viewer

  set_toolbar_to_show_both_icons_and_text \
    "${mail_preferences_plist}" \
    "NSToolbar Configuration SingleMessageViewer"

  set_toolbar_items \
    "${mail_preferences_plist}" \
    "NSToolbar Configuration SingleMessageViewer" \
    "NSToolbarFlexibleSpaceItem" \
    "FlaggedStatus" \
    "moveMessagesFromToolbar:" \
    "toggleAllHeaders:"

  report_end_phase_standard
}

function mail_app_plist_path() {
  sandboxed_plist_path_from_domain "${DEFAULTS_DOMAINS_MAIL_APP}"
}

function bomb_if_mail_app_plist_does_not_exist() {
  local plist_path

  plist_path="$(sandboxed_plist_path_from_domain "${DEFAULTS_DOMAINS_MAIL_APP}")"

  if [[ ! -f "${plist_path}" ]]; then
    report_fail "Mail.app’s preferences plist does not exist.${NEWLINE}Open Mail.app so that it can initialize its preferences, then run GenoMac again.${NEWLINE}Expected plist: ${plist_path}"
  fi
}



