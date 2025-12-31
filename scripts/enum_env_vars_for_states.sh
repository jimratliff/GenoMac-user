#!/usr/bin/env zsh

# Establishes values for environment variables that act as enums corresponding
# to states.
#
# This script is assumed to reside in the same directory as the helpers.sh 
# script of helper functions.

set -euo pipefail

# Source the helpers script
source "${GENOMAC_HELPER_DIR}/helpers.sh"

# Define environment variables corresponding to states
GENOMAC_USER_STATE_DO_ENABLE_MICROSOFT_WORD
GENOMAC_USER_STATE_DO_NOT_ENABLE_MICROSOFT_WORD
GENOMAC_USER_STATE_MICROSOFT_WORD_IS_AUTHENTICATED
GENOMAC_USER_STATE_MICROSOFT_WORD_IS_CONFIGURED
GENOMAC_USER_STATE_1PASSWORD_IS_CONFIGURED_FOR_SSH_AND_GITHUB
GENOMAC_USER_STATE_DROPBOX_IS_AUTHENTICATED
GENOMAC_USER_STATE_DROPBOX_HAS_SYNCED_COMMON_PREFS
GENOMAC_USER_STATE_BETTER_TOUCH_TOOL_LICENSE_IS_INSTALLED
GENOMAC_USER_STATE_DOCK_TOOLBARS_QL_PLUGINS_ARE_INITIALIZED
GENOMAC_USER_STATE_TEXT_EXPANDER_IS_AUTHENTICATED

# Export environment variables to be available in all subsequent shells
report_action_taken "Exporting environment variables corresponding to states."

function export_and_report() {
  local var_name="$1"
  report "export $var_name: '${(P)var_name}'"
  export "$var_name"
}

export_and_report GENOMAC_USER_STATE_DO_ENABLE_MICROSOFT_WORD
export_and_report GENOMAC_USER_STATE_DO_NOT_ENABLE_MICROSOFT_WORD
export_and_report GENOMAC_USER_STATE_1PASSWORD_IS_CONFIGURED_FOR_SSH_AND_GITHUB
export_and_report GENOMAC_USER_STATE_DROPBOX_IS_AUTHENTICATED
export_and_report GENOMAC_USER_STATE_DROPBOX_HAS_SYNCED_COMMON_PREFS
export_and_report GENOMAC_USER_STATE_BETTERTOUCHTOOL_LICENSE_IS_INSTALLED
export_and_report GENOMAC_USER_STATE_DOCK_TOOLBARS_QL_PLUGINS_ARE_INITIALIZED
