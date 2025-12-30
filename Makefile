# --------------------------------------------------------------------
# Phony targets (not real files)
# --------------------------------------------------------------------
.PHONY: \
    stow-dotfiles \
    initial-prefs \
	execute_one_time_per_user \
    verify-ssh-agent \
	btt-license \
	defaults_detective \

# --------------------------------------------------------------------
# Targets
# --------------------------------------------------------------------

stow-dotfiles:
	zsh scripts/stow_dotfiles.sh

initial-prefs:
	zsh scripts/initial_prefs.sh

bootstrap-user:
	zsh scripts/execute_one_time_per_user.sh

verify-ssh-agent:
	zsh scripts/verify_ssh_agent_setup.sh

btt-license:
	zsh scripts/install_BTT_license.sh

after-dropbox-syncs-common-prefs:
	zsh scripts/after_dropbox_syncs_common_prefs.sh

apps-that-launch-on-login:
	zsh scripts/apps_that_launch_on_login.sh

defaults-detective:
	zsh scripts/defaults_detective.sh

