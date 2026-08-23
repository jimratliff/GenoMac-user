#!/usr/bin/env zsh

function conditionally_configure_mail_app() {
  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_APPLE_MAIL_APP_USER_WANTS_IT"; then
    report_action_taken_to_log "Skipping Mail.app configuration, because this user doesn’t want it"
    report_end_phase_standard
    return 0
  fi

  run_if_user_has_not_done \
    "$PERM_APPLE_MAIL_APP_ACCOUNTS_HAVE_BEEN_CONFIGURED" \
    interactively_configure_accounts_for_Mail_app \
    "Skipping interactively configuring accounts for Mail.app because it’s been done in the past"

  run_if_user_has_not_done \
    "$PERM_APPLE_MAIL_APP_HAS_BEEN_BOOTSTRAPPED" \
    bootstrap_toolbars_for_mail_app \
    "Skipping bootstrapping Mail.app because it’s been done in the past"

  configure_mail_app_idempotent_settings

  report_end_phase_standard
}

function interactively_configure_accounts_for_Mail_app() {
  # Interactively configure at least one account for Mail.app

  ############### TODO! WIP!
  
  report_start_phase_standard

  report "Time to configure at least email account in Mail.app!${NEWLINE}I’ll launch it, and open a window with instructions for next steps"
	
  launch_app_and_prompt_user_to_act \
    --show-doc "${GMU_DOCS_TO_DISPLAY}/Mail_app_how_to_configure_accounts.md" \
    "$BUNDLE_ID_MAIL_APP" \
    "Follow the instructions in the Quick Look window to log into and configure at least one account in Mail.app"
  
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


