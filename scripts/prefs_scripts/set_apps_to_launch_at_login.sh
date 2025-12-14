#!/usr/bin/env zsh
# GenoMac-user: declaratively launch selected apps at user login via LaunchAgents.
#
# Policy:
# - One LaunchAgent plist per app.
# - The plist is regenerated each run.
# - The LaunchAgent is (re)activated ONLY if the on-disk plist was added/changed.
#
# Naming:
#   File:  ~/Library/LaunchAgents/com.virtualperfection.genomac.login.<bundle_id>.plist
#   Label: com.virtualperfection.genomac.login.<bundle_id>
#
# Notes:
# - Using bundle IDs lets /usr/bin/open locate the app via Launch Services, even if the app lives
#   in a nonstandard path (e.g., Keyboard Maestro Engine.app inside another app bundle).
# - If you want “disk only” behavior, comment out the launchctl section in
#   genomac_install_login_agent_for_bundle_id().

set -euo pipefail

###############################################################################
# Configuration: list of bundle IDs to launch at user login
###############################################################################

# typeset -a declares an array (zsh). Elements are your bundle IDs.
typeset -a GENOMAC_LOGIN_BUNDLE_IDS=(
  "com.stairways.keyboardmaestro.engine"
  "com.runningwithcrayons.Alfred"
  "studio.retina.Alan"
  "com.smileonmymac.textexpander"
  "com.getdropbox.dropbox"
  "ua.com.AntLogic.Antnotes"
  "com.hegenberg.BetterTouchTool"
  "com.sync.desktop%"
)

###############################################################################
# Internals
###############################################################################

genomac_loginagents_dir() {
  echo "$HOME/Library/LaunchAgents"
}

genomac_loginagent_label_for_bundle_id() {
  local bundle_id="$1"
  echo "com.virtualperfection.genomac.login.${bundle_id}"
}

genomac_loginagent_plist_path_for_bundle_id() {
  local bundle_id="$1"
  echo "$(genomac_loginagents_dir)/com.virtualperfection.genomac.login.${bundle_id}.plist"
}

genomac_write_loginagent_plist_to_tmp() {
  local bundle_id="$1"
  local label="$2"
  local tmp_plist="$3"

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
    <string>-b</string>
    <string>${bundle_id}</string>
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
genomac_install_loginagent_file_if_changed() {
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
genomac_install_login_agent_for_bundle_id() {
  local bundle_id="$1"
  local label plist_path tmp_plist

  label="$(genomac_loginagent_label_for_bundle_id "$bundle_id")"
  plist_path="$(genomac_loginagent_plist_path_for_bundle_id "$bundle_id")"

  # mktemp template: the XXXXXX is replaced with random characters to ensure uniqueness.
  tmp_plist="$(mktemp "${TMPDIR:-/tmp}/genomac-loginagent.XXXXXX.plist")"

  genomac_write_loginagent_plist_to_tmp "$bundle_id" "$label" "$tmp_plist"

  if genomac_install_loginagent_file_if_changed "$tmp_plist" "$plist_path"; then
    # Plist changed/new: reload it into the current GUI session.
    # - bootout removes any already-loaded job with this label (ignore errors if not loaded).
    # - bootstrap loads from the updated plist; with RunAtLoad=true, it will run now.
    launchctl bootout "gui/$(id -u)" "$label" 2>/dev/null || true
    launchctl bootstrap "gui/$(id -u)" "$plist_path" 2>/dev/null || true
  else
    # Unchanged: don’t reload (avoids unexpectedly re-launching apps).
    rm -f "$tmp_plist" 2>/dev/null || true
  fi
}

genomac_install_login_agents() {
  local bundle_id
  for bundle_id in "${GENOMAC_LOGIN_BUNDLE_IDS[@]}"; do
    genomac_install_login_agent_for_bundle_id "$bundle_id"
  done
}

# Remove GenoMac-managed login agents that are no longer declared in
# GENOMAC_LOGIN_BUNDLE_IDS.
genomac_prune_login_agents() {
  local dir prefix uid
  dir="$(genomac_loginagents_dir)"
  prefix="com.virtualperfection.genomac.login."
  uid="$(id -u)"

  # Build a set of desired plist paths.
  typeset -A desired_plist_paths
  local bundle_id desired_path
  for bundle_id in "${GENOMAC_LOGIN_BUNDLE_IDS[@]}"; do
    desired_path="$(genomac_loginagent_plist_path_for_bundle_id "$bundle_id")"
    desired_plist_paths["$desired_path"]=1
  done

  # Iterate over managed plists on disk and remove those not in the desired set.
  # null_glob ensures the loop is empty (not literal) if no files match.
  local oldopt
  oldopt="$(setopt)"
  setopt null_glob

  local plist_path base label
  for plist_path in "$dir"/${prefix}*.plist; do
    # Skip if it's still desired.
    if [[ -n "${desired_plist_paths["$plist_path"]:-}" ]]; then
      continue
    fi

    # Derive label from filename stem (basename without .plist)
    base="${plist_path:t}"
    label="${base%.plist}"

    # Unload if loaded (ignore errors), then delete.
    launchctl bootout "gui/${uid}" "$label" 2>/dev/null || true
    rm -f "$plist_path"
  done

  # Restore options (best-effort).
  eval "$oldopt" 2>/dev/null || true
}

###############################################################################
# Entry point
###############################################################################

genomac_install_login_agents
