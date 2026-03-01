#!/usr/bin/env zsh


# set_apps_to_launch_at_login(): Declaratively ensure selected apps launch at user login via LaunchAgents.
#
# Policy:
# - One LaunchAgent plist per declared app (keyed by a stable name).
# - Plists are regenerated each run and replaced only if content changes.
# - LaunchAgent labels/filenames are namespaced by $GENOMAC_NAMESPACE (e.g., com.virtualperfection.genomac).
# - No launchctl calls are performed here (“disk only”): changes take effect on next login.
# - Any previously generated ${GENOMAC_NAMESPACE}.login.* plists that are no longer declared are removed.
#
# Naming (assuming $GENOMAC_NAMESPACE is com.virtualperfection.genomac):
#   File:  ~/Library/LaunchAgents/com.virtualperfection.genomac.login.<stable_name>.plist
#   Label: com.virtualperfection.genomac.login.<stable_name>
#
# Launch method per app:
# - bundle:<bundle_id>  -> /usr/bin/open -b <bundle_id>
# - path:<app_path>     -> /usr/bin/open -a <app_path>

set -euo pipefail

: "${GENOMAC_NAMESPACE:?❌ GENOMAC_NAMESPACE must be set (e.g., com.virtualperfection.genomac)}"

###############################################################################
# CONFIGURE THE LIST OF APPS TO LAUNCH AT LOGIN HERE!
#
# Notes: 
# - Sync.com is appropriate for only some users and is not present here.
#   Use of the Sync app requires some manual intervention by the user in any case, during
#   which it’s likely that this app will be manually specified to launch at login.
#
# - The following apps *do* launch at user login, but aren’t handled here because they
# 	have their own login helper:
# 	- Dropbox: 			"bundle:com.getdropbox.dropbox"
# 	- TextExpander	"bundle:com.smileonmymac.textexpander"
#
###############################################################################

# GENOMAC_LOGIN_APPS
# Declarative specification of apps to launch at login.
#
# Two alternative formats:
#   [stable_name]="bundle:<bundle_id>"
#   [stable_name]="path:<absolute_app_path>"
#
# The key (stable_name) is used to form the LaunchAgent label and filename:
#   ${GENOMAC_NAMESPACE}.login.<stable_name>
#
# The "bundle"/"path" value determines how the app is launched.
#

typeset -g -A GENOMAC_LOGIN_APPS=(
  [alan]="bundle:${BUNDLE_ID_ALAN_APP}"
)

GENOMAC_LOGIN_APPS[bettertouchtool]="bundle:${BUNDLE_ID_BETTERTOUCHTOOL}"

# path-based launch (nested app bundle; bundle-id unreliable at login)
GENOMAC_LOGIN_APPS[keyboard-maestro-engine]="path:/Applications/Keyboard Maestro.app/Contents/MacOS/Keyboard Maestro Engine.app"

# I’m leaving the following commented out because they might auto-launch without this intervention.
# If that turns out not to be true for any, just uncomment the line corresponding to that app.
# Uncomment to enable:
# GENOMAC_LOGIN_APPS[alfred]="bundle:${BUNDLE_ID_ALFRED}"


function conditionally_set_apps_to_launch_at_login() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$SESH_APPS_TO_LAUNCH_AT_LOGIN_HAVE_BEEN_SPECIFIED" \
    set_apps_to_launch_at_login \
    "Skipping specifications of apps to launch at login, because they’ve already been specified this session"
	
  report_end_phase_standard
}

function set_apps_to_launch_at_login() {
  # Dispatcher: installs all declared login agents (and prunes removed ones).
  # Expects:
  #   - GENOMAC_NAMESPACE
  #   - GENOMAC_LOGIN_APPS (assoc array): [name]="bundle:<bundle_id>" or [name]="path:<app_path>"
  #   - install_loginagent_file_if_changed <tmp_plist> <dst_plist>
  #   - print_loginagents_dir
  #   - prune_login_agents

  report_start_phase_standard
  
  : "${GENOMAC_LOGIN_APPS:?GENOMAC_LOGIN_APPS must be set (assoc array)}"

  local name spec kind value label tmp_plist plist_path

  for name spec in ${(kv)GENOMAC_LOGIN_APPS}; do
    kind="${spec%%:*}"
    value="${spec#*:}"

    if [[ "$kind" != "bundle" && "$kind" != "path" ]]; then
      report_fail "Unknown launch spec kind: '$kind' in GENOMAC_LOGIN_APPS[$name]=$spec"
      return 1
    fi

    label="${GENOMAC_NAMESPACE}.login.${name}"
    plist_path="$(print_loginagents_dir)/${label}.plist"
    tmp_plist="$(mktemp "${TMPDIR:-/tmp}/genomac-loginagent.XXXXXX.plist")"

    if [[ "$kind" == "path" ]]; then
      write_loginagent_plist_to_tmp --by-path "$value" "$label" "$tmp_plist"
    else
      write_loginagent_plist_to_tmp "$value" "$label" "$tmp_plist"
    fi

    if install_loginagent_file_if_changed "$tmp_plist" "$plist_path"; then
      :  # changed/added; do nothing (next login will load it)
      report_action_taken "Installed launch agent $label"
    else
      report_action_taken "Retained without change launch agent $label"
      rm -f "$tmp_plist" 2>/dev/null || true
    fi
  done
  
  prune_login_agents

  report_end_phase_standard
  
}

function print_loginagents_dir() {
  echo "$HOME/Library/LaunchAgents"
}

function write_loginagent_plist_to_tmp() {
  # Helper: generate a LaunchAgent plist that runs `open` either
  # (a) by bundle id (default) or
  # (b) by app path (when called with --by-path).
  #
  # Usage:
  #   write_loginagent_plist_to_tmp <bundle_id> <label> <tmp_plist>
  #   write_loginagent_plist_to_tmp --by-path <app_path> <label> <tmp_plist>
  local mode="bundle"

  # In shell functions, "flags" are just positional parameters ("$1", "$2", ...)
  # until you parse/shift them yourself.
  if [[ "${1:-}" == "--by-path" ]]; then
    mode="path"
    shift
  fi

  local target="${1:?missing bundle_id/path}"
  local label="${2:?missing label}"
  local tmp_plist="${3:?missing tmp_plist path}"

  local open_flag open_arg
  if [[ "$mode" == "path" ]]; then
    open_flag="-a"
    open_arg="$target"
  else
    open_flag="-b"
    open_arg="$target"
  fi

  cat >"$tmp_plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${label}</string>

  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/open</string>
    <string>${open_flag}</string>
    <string>${open_arg}</string>
  </array>

  <key>RunAtLoad</key>
  <true/>

  <key>LaunchOnlyOnce</key>
  <true/>
</dict>
</plist>
EOF
}

# Returns success (0) if the destination was updated/replaced; returns 1 if unchanged.
function install_loginagent_file_if_changed() {
  local tmp_plist="$1"
  local dst_plist="$2"

  mkdir -p "$(dirname "$dst_plist")"

  if [[ -f "$dst_plist" ]] && cmp -s "$tmp_plist" "$dst_plist"; then
    return 1  # unchanged
  fi

  mv -f "$tmp_plist" "$dst_plist"
  return 0  # changed/added
}

function prune_login_agents() {
  # Remove GenoMac-managed login agents that are no longer declared in
  # GENOMAC_LOGIN_APPS.
  emulate -L zsh
  setopt null_glob

  local dir prefix
  report_start_phase_standard

  dir="$(print_loginagents_dir)"
  prefix="${GENOMAC_NAMESPACE}.login."

  # Build a set of desired plist paths (based on GENOMAC_LOGIN_APPS keys).
  typeset -A desired_plist_paths
  local name desired_path
  for name in ${(k)GENOMAC_LOGIN_APPS}; do
    desired_path="${dir}/${GENOMAC_NAMESPACE}.login.${name}.plist"
    desired_plist_paths["$desired_path"]=1
  done

  local plist_path
  for plist_path in "$dir"/${prefix}*.plist; do
    # Skip if it's still desired.
    if [[ -n "${desired_plist_paths["$plist_path"]:-}" ]]; then
      continue
    fi

    report_action_taken "Removing from login items: «$plist_path»"
    rm -f "$plist_path"
  done

  report_end_phase_standard
}
