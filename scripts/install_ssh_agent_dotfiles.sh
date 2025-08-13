#!/usr/bin/env zsh

# Deploys the three dotfiles required for (a) configuring 1Password’s SSH agent and
# (b) configuring the SSH client to use 1Password SSH agent as the default SSH agent

set -euo pipefail

# Resolve the directory in which this file lives (even when sourced)
this_script_path="${(%):-%N}"
this_script_dir="${this_script_path:A:h}"

# Specify the directory in which the `helpers.sh` file lives.
# E.g., when `helpers.sh` lives at the same level as this script:
# GENOMAC_BOOTSTRAP_HELPER_DIR="${this_script_dir}"
GENOMAC_BOOTSTRAP_HELPER_DIR="${this_script_dir}"

# Print assigned paths for diagnostic purposes
printf "\n📂 Path diagnostics:\n"
printf "this_script_dir:              %s\n" "$this_script_dir"
printf "GENOMAC_BOOTSTRAP_HELPER_DIR: %s\n" "$GENOMAC_BOOTSTRAP_HELPER_DIR"

source "${GENOMAC_BOOTSTRAP_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################
function install_ssh_agent_dotfiles() {
report_start_phase_standard

# Specify location into which this repo is cloned
REPO_LOCAL_PATH=~/bootstrap

# Define root-relative source and destination base
SRC_BASE="$REPO_LOCAL_PATH/files/home"
DEST_BASE="$HOME"

# List of files relative to $SRC_BASE and $DEST_BASE
dotfiles=(
  ".config/1Password/ssh/agent.toml"
  ".ssh/config"
  ".zshrc"
)

for rel_path in $dotfiles; do
  src="$SRC_BASE/$rel_path"
  dest="$DEST_BASE/$rel_path"

  # Ensure destination directory exists
  mkdir -p "${dest:h}"

  # Copy (and overwrite if necessary)
  report_action_taken "Copying \"${src/#$HOME/~}\" to \"${dest/#$HOME/~}\""
  cp "$src" "$dest"; success_or_not
done

report_end_phase_standard

}

function main() {
  install_ssh_agent_dotfiles
}

main
