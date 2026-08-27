#!/usr/bin/env zsh

# NOTE: The email accounts for Mail.app are established throught the System Settings » Internet Account interface,
#       NOT through the Mail.app Settings » Accounts interface.
#
#       Currently, it is assumed that Internet Accounts are desired only for users of Mail.app.

function conditionally_configure_mail_app() {
  report_start_phase_standard

  if ! test_genomac_user_state "$SESH_APPLE_MAIL_APP_USER_WANTS_IT"; then
    report_action_taken_to_log "Skipping configuring Internet Accounts and Mail.app, because this user doesn’t want these"
    report_end_phase_standard
    return 0
  fi

  run_if_user_has_not_done \
    "$PERM_INTERNET_ACCOUNTS_HAVE_BEEN_CONFIGURED" \
    interactively_configure_internet_accounts \
    "Skipping interactively configuring internet accounts because it’s been done in the past"

  if ! test_genomac_user_state "$PERM_INTERNET_ACCOUNTS_HAVE_BEEN_CONFIGURED" ; then
    report_warning "Skipping remainder of configuring Mail.app because no evidence that any internet accounts have been configured."
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

function interactively_configure_internet_accounts() {
  # Interactively configure at least one internet account.
  #
  # - Looks for an optional user-specific Markdown file in $USER_SPECIFIC_META_DIRECTORY
  #   to be displayed via QuickLook to guide the user through interactively configuring
  #   internet accounts.
  # - If this file is not present, an alternative, default document is displayed instead.
  
  report_start_phase_standard

  local markdown_file_to_display="${GMU_DOCS_TO_DISPLAY}/Internet_Accounts_how_to_configure_accounts.md"

  # Looks for optional user-specific Markdown file $USER_SPECIFIC_INTERNET_ACCOUNTS_SPECIFICATIONS_FILE
  # in $USER_SPECIFIC_META_DIRECTORY (Dropbox/Prefs/Meta).
  # If present, displays to user. Otherwise, displays the alternative, default Markdown document
  # "Internet_Accounts_how_to_configure_accounts.md" from GenoMac-user.

  if [[ ! -e "${USER_SPECIFIC_INTERNET_ACCOUNTS_SPECIFICATIONS_FILE}" ]]; then
    report_to_log "No user-specific internet-accounts instructions exist for user ${USER}."
  elif [[
    ! -f "${USER_SPECIFIC_INTERNET_ACCOUNTS_SPECIFICATIONS_FILE}" ||
    ! -r "${USER_SPECIFIC_INTERNET_ACCOUNTS_SPECIFICATIONS_FILE}"
  ]]; then
    report_fail "The user-specific internet-accounts instructions exist but aren’t a readable regular file.${NEWLINE}See ${USER_SPECIFIC_INTERNET_ACCOUNTS_SPECIFICATIONS_FILE}"
    return 1
  else
    markdown_file_to_display="${USER_SPECIFIC_INTERNET_ACCOUNTS_SPECIFICATIONS_FILE}"
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

#######################################################################################################################################
#         DEPRECATION ZONE
#
#         ALL CODE BELOW IS HENCEFORTH DEPRECATED
#

# function get_URL_for_rendered_user_specific_email_accounts_markdown_page() {
#   # Renders the user-specific Markdown file in GenoMac-private, if it exists, that supplies
#   # non-public detail about the email user accounts to be implemented in Mail.app.
#   
#   report_start_phase_standard
#   
#   local github_pat="$1"
# 
#   local repository_api_url
#   local contents_api_url
#   local temporary_directory
#   local rendered_fragment_path
#   local rendered_page_path
#   local http_status
#   local curl_status
# 
#   repository_api_url="${GENOMAC_COMMON_GITHUB_API_REPOS_URL_ROOT}/${GENOMAC_PRIVATE_REPO_NAME}"
#   contents_api_url="${repository_api_url}/contents/${USER_SPECIFIC_EMAIL_ACCOUNTS_MARKDOWN_REPO_PATH}"
# 
#   temporary_directory="$(mktemp -d "${TMPDIR%/}/genomac-email-account-instructions.XXXXXX")" || {
#     report_fail "Couldn’t create a temporary directory for the email-account instructions."
#     return 1
#   }
# 
#   rendered_fragment_path="${temporary_directory}/rendered-fragment.html"
#   rendered_page_path="${temporary_directory}/email-account-instructions.html"
# 
#   chmod 700 "${temporary_directory}" || {
#     report_fail "Couldn’t secure the temporary email-account instructions directory."
#     return 1
#   }
# 
#   # Establish that the PAT can access GenoMac-private. This is necessary
#   # because GitHub can return 404 both for a nonexistent file and for an
#   # inaccessible private repository.
#   http_status="$(
#     curl \
#       --silent \
#       --show-error \
#       --output /dev/null \
#       --write-out '%{http_code}' \
#       --header "Accept: application/vnd.github+json" \
#       --header "Authorization: Bearer ${github_pat}" \
#       --header "X-GitHub-Api-Version: 2022-11-28" \
#       "${repository_api_url}"
#   )"
#   curl_status=$?
# 
#   if (( curl_status != 0 )) || [[ "${http_status}" != "200" ]]; then
#     rm -rf "${temporary_directory}"
# 
#     report_fail "Couldn’t access the private GenoMac GitHub repository."
#     return 1
#   fi
# 
#   # Ask GitHub to return the Markdown rendered as HTML.
#   http_status="$(
#     curl \
#       --silent \
#       --show-error \
#       --output "${rendered_fragment_path}" \
#       --write-out '%{http_code}' \
#       --header "Accept: application/vnd.github.html+json" \
#       --header "Authorization: Bearer ${github_pat}" \
#       --header "X-GitHub-Api-Version: 2022-11-28" \
#       --get \
#       --data-urlencode "ref=${GENOMAC_PRIVATE_DEFAULT_BRANCH}" \
#       "${contents_api_url}"
#   )"
#   curl_status=$?
# 
#   if (( curl_status != 0 )); then
#     rm -rf "${temporary_directory}"
# 
#     report_fail "An error occurred while retrieving the email-account instructions."
#     return 1
#   fi
# 
#   case "${http_status}" in
#     200)
#       ;;
# 
#     404)
#       rm -rf "${temporary_directory}"
#       report_to_log "The user-specific Markdown file doesn’t exist. This isn’t fatal."
#       report_end_phase_standard
#       return 3
#       ;;
# 
#     *)
#       rm -rf "${temporary_directory}"
# 
#       report_fail "GitHub returned HTTP status ${http_status} while retrieving the email-account instructions."
#       return 1
#       ;;
#   esac
# 
#   if ! write_rendered_markdown_html_document \
#     "${rendered_fragment_path}" \
#     "${rendered_page_path}" \
#     "$TITLE_OF_USER_SPECIFIC_EMAIL_ACCOUNTS_MARKDOWN_PAGE"; then
#     command rm -rf "${temporary_directory}"
# 
#     report_fail "Couldn’t prepare the email-account instructions for display."
#     return 1
#   fi
# 
#   command rm -f "${rendered_fragment_path}"
# 
#   if ! printf 'file://%s\n' "${rendered_page_path}"; then
#     command rm -rf "${temporary_directory}"
# 
#     report_fail "Couldn’t return the URL for the email-account instructions."
#     return 1
#   fi
#   
#   report_end_phase_standard
# }


