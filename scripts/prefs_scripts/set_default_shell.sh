# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_default_shell() {
  # Ensure user’s login shell is the Homebrew-installed version of zsh (idempotent)
  
  report_start_phase_standard
  report_action_taken "Ensure Homebrew’s Zsh is user’s default shell"
  
  local HOMEBREW_PREFIX="$(/usr/bin/env brew --prefix)"   # e.g., /opt/homebrew
  local BREW_ZSH="$HOMEBREW_PREFIX/bin/zsh"

  if [[ ! -x "$BREW_ZSH" ]]; then
    report_fail "$BREW_ZSH not found. Did 'brew bundle' install zsh yet?"
    return 1
  fi
  
  if ! grep -qx "$BREW_ZSH" /etc/shells; then
    report_fail "$BREW_ZSH is not listed as allowable shell in /etc/shells."
    return 1
  fi

  local CURRENT_SHELL
  CURRENT_SHELL="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk 'NR==1{print $2}')"

  if [[ "$CURRENT_SHELL" == "$BREW_ZSH" ]]; then
    report_success "$USER already uses $BREW_ZSH"
  else
    report_adjust_setting "Switching $USER to $BREW_ZSH"
    chsh -s "$BREW_ZSH" ; success_or_not
    report "Open a new login shell (new Terminal window or 'zsh -l') for it to take effect."
  fi

  report_end_phase_standard
}
