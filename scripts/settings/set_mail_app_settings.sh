#!/usr/bin/env zsh

conditionally_configure_mail_app() {
  # TODO conditionally_configure_mail_app
  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_APPLE_MAIL_APP_USER_WANTS_IT"; then
    report_action_taken_to_log "Skipping Mail.app configuration, because this user doesn’t want it"
    report_end_phase_standard
    return 0
  fi
  
  run_if_user_has_not_done \
    "$PERM_APPLE_MAIL_APP_HAS_BEEN_BOOTSTRAPPED" \
    bootstrap_toolbars_for_mail_app \
    "Skipping bootstrapping Mail.app because it’s been done in the past"

  configure_mail_app_idempotent_settings
    
  report_end_phase_standard
}

function configure_mail_app_idempotent_settings() {
  # Configure Mail.app idempotent settings
  report_start_phase_standard

  quit_app_by_bundle_id_if_running "$BUNDLE_ID_MAIL_APP"

  # Settings » General » New messages notifications
  report_adjust_setting "Provide new-message notification for new messages in *all* mailboxes, not just Inbox"
  defaults write "$DEFAULTS_DOMAINS_MAIL_APP" MailUserNotificationScope -int 5 ; success_or_not

  # Settings » Viewing » List preview
  report_adjust_setting "Provide 3 lines of message summary"
  defaults write "$DEFAULTS_DOMAINS_MAIL_APP" NumberOfSnippetLines -int 3
  
  report_end_phase_standard
}

function bootstrap_toolbars_for_mail_app() {
  # Bootstrap the toolbars for main-window and single-message-viewer windows.
  report_start_phase_standard

  local mail_preferences_plist="$(sandboxed_plist_path_from_domain "${BUNDLE_ID_MAIL_APP}")

  quit_app_by_bundle_id_if_running "${BUNDLE_ID_MAIL_APP}"

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
    "moveMessagesFromToolbar:" \
    "toggleAllHeaders:"

  report_end_phase_standard
}




