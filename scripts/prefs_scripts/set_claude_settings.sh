#!/bin/zsh

function set_claude_settings() {

  # Specify settings for Claude
  # - Turn off quick-entry shortcut
  # - Turn off menubar item

  report_start_phase_standard
  report_action_taken "Implement Claude desktop settings"

  local claude_config_path="${HOME}/Library/Application Support/Claude/claude_desktop_config.json"
  local claude_config_dir="${claude_config_path:h}"
  local tmpfile

  # Single jq filter to apply once
  local jq_filter='
    .preferences = (.preferences // {}) |
    .preferences.quickEntryShortcut = "off" |
    .preferences.menuBarEnabled = false
  '

  # If the directory doesn't exist yet, give Claude a chance to create it by launching and quitting
  if [[ ! -d "${claude_config_dir}" ]]; then
    report_action_taken "Claude support directory not found; launching Claude once to seed config"
    launch_and_quit_app "${BUNDLE_ID_CLAUDE}" ; success_or_not
  fi

  report_action_taken "Ensure Claude config directory exists: ${claude_config_dir}"
  mkdir -p "${claude_config_dir}" ; success_or_not

  # Ensure the JSON config file exists in some minimal form.
  if [[ ! -f "${claude_config_path}" || ! -s "${claude_config_path}" ]]; then
    report_action_taken "Initialize Claude config file if missing/empty: ${claude_config_path}"
    printf '%s\n' '{}' > "${claude_config_path}" ; success_or_not
  fi

  # Modify preferences in a single jq pass.
  tmpfile="$(mktemp "${TMPDIR:-/tmp}/claude_config.XXXXXX")"

  report_action_taken "Apply Claude preference updates via jq"
  jq "${jq_filter}" "${claude_config_path}" > "${tmpfile}" ; success_or_not

  report_action_taken "Save updated Claude config to ${claude_config_path}"
  mv "${tmpfile}" "${claude_config_path}" ; success_or_not

  report_end_phase_standard
}
