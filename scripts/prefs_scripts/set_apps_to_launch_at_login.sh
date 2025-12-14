# set_apps_to_launch_at_login(): Declaratively launch selected apps at user login via LaunchAgents.
#
# Policy:
# - One LaunchAgent plist per app.
# - Each plist is regenerated each run.
# - The namespace for the launchagent plists is defined by $GENOMAC_NAMESPACE
#   (e.g., com.virtualperfection.genomac)
# - The LaunchAgent is (re)activated ONLY if the on-disk plist was added/changed.
# - Previously specified $GENOMAC_NAMESPACE plists that are no longer in the specification are removed.
#
# Naming (assuming $GENOMAC_NAMESPACE is com.virtualperfection.genomac):
#   File:  ~/Library/LaunchAgents/com.virtualperfection.genomac.login.<bundle_id>.plist
#   Label: com.virtualperfection.genomac.login.<bundle_id>
#
# Notes:
# - Using bundle IDs lets /usr/bin/open locate the app via Launch Services, even if the app lives
#   in a nonstandard path (e.g., Keyboard Maestro Engine.app inside another app bundle).
# - If you want “disk only” behavior, comment out the launchctl section in
#   install_login_agent_for_bundle_id().

set -euo pipefail

: "${GENOMAC_NAMESPACE:?❌ GENOMAC_NAMESPACE must be set (e.g., com.virtualperfection.genomac)}"

###############################################################################
# CONFIGURE THE LIST OF APPS TO LAUNCH AT LOGIN HERE!
#
# Note: Sync.com is appropriate for only some users and is commented out.
#       Use of the Sync app requires some manual intervention by the user in any case, during
#       which it’s likely that this app will be manually specified to launch at login.
#
###############################################################################

# typeset -a declares an array (zsh). Elements are your bundle IDs.
typeset -a -g GENOMAC_LOGIN_BUNDLE_IDS=(
#  "com.getdropbox.dropbox"       # Has its own login helper
  "com.hegenberg.BetterTouchTool"
  "com.runningwithcrayons.Alfred"
#  "com.smileonmymac.textexpander" # Has its own login helper
  "com.stairways.keyboardmaestro.engine"
#  "com.sync.desktop"
  "studio.retina.Alan"
  "ua.com.AntLogic.Antnotes"
)

set_apps_to_launch_at_login() {
  # Dispatcher: installs all declared login agents (and prunes removed ones).
  # Expects:
  #   - GENOMAC_NAMESPACE
  #   - GENOMAC_LOGIN_APPS (assoc array): [name]="bundle:<bundle_id>" or [name]="path:<app_path>"
  #   - install_loginagent_file_if_changed <tmp_plist> <dst_plist>
  #   - print_loginagents_dir
  #   - genomac_prune_login_agents
  : "${GENOMAC_NAMESPACE:?GENOMAC_NAMESPACE must be set}"
  : "${GENOMAC_LOGIN_APPS:?GENOMAC_LOGIN_APPS must be set (assoc array)}"

  local name spec kind value label tmp_plist plist_path

  for name spec in ${(kv)GENOMAC_LOGIN_APPS}; do
    kind="${spec%%:*}"
    value="${spec#*:}"

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
    else
      rm -f "$tmp_plist" 2>/dev/null || true
    fi
  done

function print_loginagents_dir() {
  echo "$HOME/Library/LaunchAgents"
}

function print_loginagent_label_for_bundle_id() {
  local bundle_id="$1"
  echo "${GENOMAC_NAMESPACE}.login.${bundle_id}"
}

function print_loginagent_plist_path_for_bundle_id() {
  local bundle_id="$1"
  echo "$(print_loginagents_dir)/${GENOMAC_NAMESPACE}.login.${bundle_id}.plist"
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

# Create/update the plist on disk, and (re)activate it only if the plist changed.
function install_login_agent_for_bundle_id() {
  local bundle_id="$1"
  local label plist_path tmp_plist

  label="$(print_loginagent_label_for_bundle_id "$bundle_id")"
  plist_path="$(print_loginagent_plist_path_for_bundle_id "$bundle_id")"

  # mktemp template: the XXXXXX is replaced with random characters to ensure uniqueness.
  tmp_plist="$(mktemp "${TMPDIR:-/tmp}/genomac-loginagent.XXXXXX.plist")"

  write_loginagent_plist_to_tmp "$bundle_id" "$label" "$tmp_plist"

  if install_loginagent_file_if_changed "$tmp_plist" "$plist_path"; then
    :  # changed/added; do nothing (next login will load it)
  else
    rm -f "$tmp_plist" 2>/dev/null || true
  fi
}

# Remove GenoMac-managed login agents that are no longer declared in
# GENOMAC_LOGIN_BUNDLE_IDS.
function genomac_prune_login_agents() {
  emulate -L zsh
  setopt null_glob
  
  local dir prefix

  report_start_phase_standard
  
  dir="$(print_loginagents_dir)"
  prefix="${GENOMAC_NAMESPACE}.login."

  # Build a set of desired plist paths.
  typeset -A desired_plist_paths
  local bundle_id desired_path
  for bundle_id in "${GENOMAC_LOGIN_BUNDLE_IDS[@]}"; do
    desired_path="$(print_loginagent_plist_path_for_bundle_id "$bundle_id")"
    desired_plist_paths["$desired_path"]=1
  done

  local plist_path
  for plist_path in "$dir"/${prefix}*.plist; do
    # Skip if it's still desired.
    if [[ -n "${desired_plist_paths["$plist_path"]:-}" ]]; then
      continue
    fi

    # Remove no-longer-desired .plist
    report_action_taken "Removing from login items: «$plist_path»"
    rm -f "$plist_path"
  done

  report_end_phase_standard
}
