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

  if ! test_genomac_user_state "$PERM_APPLE_MAIL_APP_ACCOUNTS_HAVE_BEEN_CONFIGURED" ; then
    report_warning "Skipping remainder of configuring Mail.app because user “punted” on configuring accounts."
    report_end_phase_standard
    return 0
  fi

  run_if_user_has_not_done \
    "$PERM_APPLE_MAIL_APP_TOOLBAR_HAS_BEEN_BOOTSTRAPPED" \
    bootstrap_toolbars_for_mail_app \
    "Skipping bootstrapping Mail.app because it’s been done in the past"

  configure_mail_app_idempotent_settings

  report_end_phase_standard
}

function interactively_configure_accounts_for_Mail_app() {
  # Interactively configure at least one account for Mail.app
  #
  # Looks for an optional user-specific Markdown file in GenoMac-private that lists specific accounts
  # for the user to implement in Mail.app and display it.
  
  report_start_phase_standard

  local github_pat
  github_pat="$(get_GitHub_PAT_for_GenoMac_private_from_1Password_vault)"

  local -a arguments_for_launch_app_and_prompt_user_to_act
  arguments_for_launch_app_and_prompt_user_to_act=(
    --show-doc
    "${GMU_DOCS_TO_DISPLAY}/Mail_app_how_to_configure_accounts.md"
    )

  # Looks for optional user-specific Markdown file in GenoMac-private. If present, renders it as HTML
  # and displays to user (in addition to the display of the Markdown document "Mail_app_how_to_configure_accounts.md"
  # from GenoMac-user).

  local rendered_markdown_page_status
  local URL_for_rendered_user_specific_email_accounts_markdown_page
  
  if URL_for_rendered_user_specific_email_accounts_markdown_page="$(get_URL_for_rendered_user_specific_email_accounts_markdown_page "$github_pat")"; then
    arguments_for_launch_app_and_prompt_user_to_act+=(
      --open
      "${URL_for_rendered_user_specific_email_accounts_markdown_page}"
      )
    report "The default browser has opened a window which tells you which email account should be added for this user."
  else
    rendered_markdown_page_status=$?
    case "${rendered_markdown_page_status}" in
      3)
        report "No user-specific email-account instructions exist for user ${USER}."
        ;;
      *)
        report_fail "Couldn’t prepare the user-specific email-account instructions for user ${USER}"
        return 1
        ;;
    esac
  fi

  # Incorporate positional arguments
  arguments_for_launch_app_and_prompt_user_to_act+=(
    "${BUNDLE_ID_MAIL_APP}"
    "Follow the instructions in the Quick Look window to log into and configure at least one account in Mail.app"
    )

  report "Time to configure at least one email account in Mail.app!${NEWLINE}I’ll launch it, and open a window with instructions for next steps"
  launch_app_and_prompt_user_to_act "${arguments_for_launch_app_and_prompt_user_to_act[@]}"
  
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

function get_URL_for_rendered_user_specific_email_accounts_markdown_page() {
  # Renders the user-specific Markdown file in GenoMac-private, if it exists, that supplies
  # non-public detail about the email user accounts to be implemented in Mail.app.
  
  report_start_phase_standard
  
  local github_pat="$1"

  local repository_api_url
  local contents_api_url
  local temporary_directory
  local rendered_fragment_path
  local rendered_page_path
  local http_status
  local curl_status

  repository_api_url="${GENOMAC_COMMON_GITHUB_API_REPOS_URL_ROOT}/${GENOMAC_PRIVATE_REPO_NAME}"
  contents_api_url="${repository_api_url}/contents/${USER_SPECIFIC_EMAIL_ACCOUNTS_MARKDOWN_REPO_PATH}"

  temporary_directory="$(mktemp -d "${TMPDIR%/}/genomac-email-account-instructions.XXXXXX")" || {
    report_fail "Couldn’t create a temporary directory for the email-account instructions."
    return 1
  }

  rendered_fragment_path="${temporary_directory}/rendered-fragment.html"
  rendered_page_path="${temporary_directory}/email-account-instructions.html"

  chmod 700 "${temporary_directory}" || {
    report_fail "Couldn’t secure the temporary email-account instructions directory."
    return 1
  }

  # Establish that the PAT can access GenoMac-private. This is necessary
  # because GitHub can return 404 both for a nonexistent file and for an
  # inaccessible private repository.
  http_status="$(
    curl \
      --silent \
      --show-error \
      --output /dev/null \
      --write-out '%{http_code}' \
      --header "Accept: application/vnd.github+json" \
      --header "Authorization: Bearer ${github_pat}" \
      --header "X-GitHub-Api-Version: 2022-11-28" \
      "${repository_api_url}"
  )"
  curl_status=$?

  if (( curl_status != 0 )) || [[ "${http_status}" != "200" ]]; then
    rm -rf "${temporary_directory}"

    report_fail "Couldn’t access the private GenoMac GitHub repository."
    return 1
  fi

  # Ask GitHub to return the Markdown rendered as HTML.
  http_status="$(
    curl \
      --silent \
      --show-error \
      --output "${rendered_fragment_path}" \
      --write-out '%{http_code}' \
      --header "Accept: application/vnd.github.html+json" \
      --header "Authorization: Bearer ${github_pat}" \
      --header "X-GitHub-Api-Version: 2022-11-28" \
      --get \
      --data-urlencode "ref=${GENOMAC_PRIVATE_DEFAULT_BRANCH}" \
      "${contents_api_url}"
  )"
  curl_status=$?

  if (( curl_status != 0 )); then
    rm -rf "${temporary_directory}"

    report_fail "An error occurred while retrieving the email-account instructions."
    return 1
  fi

  case "${http_status}" in
    200)
      ;;

    404)
      rm -rf "${temporary_directory}"
      report_to_log "The user-specific Markdown file doesn’t exist. This isn’t fatal."
      report_end_phase_standard
      return 3
      ;;

    *)
      rm -rf "${temporary_directory}"

      report_fail "GitHub returned HTTP status ${http_status} while retrieving the email-account instructions."
      return 1
      ;;
  esac

  if ! write_rendered_markdown_html_document \
    "${rendered_fragment_path}" \
    "${rendered_page_path}" \
    "$TITLE_OF_USER_SPECIFIC_EMAIL_ACCOUNTS_MARKDOWN_PAGE"; then
    command rm -rf "${temporary_directory}"

    report_fail "Couldn’t prepare the email-account instructions for display."
    return 1
  fi

  command rm -f "${rendered_fragment_path}"

  if ! printf 'file://%s\n' "${rendered_page_path}"; then
    command rm -rf "${temporary_directory}"

    report_fail "Couldn’t return the URL for the email-account instructions."
    return 1
  fi
  
  report_end_phase_standard
}


