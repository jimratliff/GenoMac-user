# --------------------------------------------------------------------
# Phony targets (not real files)
# --------------------------------------------------------------------
.PHONY: \
    stow-dotfiles \
    initial-prefs \
    verify-ssh-agent \
	defaults_detective \

# --------------------------------------------------------------------
# Targets
# --------------------------------------------------------------------

stow-dotfiles:
	zsh scripts/stow_dotfiles.sh

initial-prefs:
	zsh scripts/initial_prefs.sh

verify-ssh-agent:
	zsh scripts/verify_ssh_agent_setup.sh

defaults_detective:
	zsh scripts/defaults_detective.sh
