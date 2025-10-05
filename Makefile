# --------------------------------------------------------------------
# Phony targets (not real files)
# --------------------------------------------------------------------
.PHONY: \
    stow-dotfiles \
    initial-prefs \
	execute_one_time_per_user \
    verify-ssh-agent \
	defaults_detective \

# --------------------------------------------------------------------
# Targets
# --------------------------------------------------------------------

stow-dotfiles:
	zsh scripts/stow_dotfiles.sh

initial-prefs:
	zsh scripts/initial_prefs.sh

btt-license:
	zsh scripts/install_BTT_license.sh

bootstrap-user:
	zsh scripts/execute_one_time_per_user.sh

verify-ssh-agent:
	zsh scripts/verify_ssh_agent_setup.sh

defaults-detective:
	zsh scripts/defaults_detective.sh

