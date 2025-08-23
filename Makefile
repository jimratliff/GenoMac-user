# --------------------------------------------------------------------
# Phony targets (not real files)
# --------------------------------------------------------------------
.PHONY: \
    stow-dotfiles \
    initial-prefs \
    verify-ssh-agent \
	determine-defaults-commands-corresponding-to-settings-change \

# --------------------------------------------------------------------
# Targets
# --------------------------------------------------------------------

stow-dotfiles:
	zsh scripts/stow_dotfiles.sh

initial-prefs:
	zsh scripts/initial_prefs.sh

verify-ssh-agent:
	zsh scripts/verify_ssh_agent_setup.sh

determine-defaults-commands-corresponding-to-settings-change:
	zsh scripts/defaults_detective/find_diff_from_setting_change.sh
