# --------------------------------------------------------------------
# Phony targets (not real files)
# --------------------------------------------------------------------
.PHONY: \
	after-dropbox-syncs-common-prefs \
	apps-that-launch-on-login \
	bootstrap-user \
	btt-license \
	defaults_detective \
	execute_one_time_per_user \
	initial-prefs \
	reset-state \
	run-hypervisor \
	sign-in-to-selected-apps \
	stow-dotfiles \
	test-refactor \
	test-state-management \
	verify-ssh-agent \

# --------------------------------------------------------------------
# Targets
# --------------------------------------------------------------------

test-refactor:
	zsh scripts/test_refactor.sh

test-state-management:
	zsh scripts/test_state_management.sh

run-hypervisor:
	zsh scripts/run_hypervisor.sh

stow-dotfiles:
	zsh scripts/stow_dotfiles.sh

initial-prefs:
	zsh scripts/initial_prefs.sh

bootstrap-user:
	zsh scripts/execute_one_time_per_user.sh

verify-ssh-agent:
	zsh scripts/verify_ssh_agent_setup.sh

sign-in-to-selected-apps:
	zsh scripts/sign_in_to_selected_apps.sh

btt-license:
	zsh scripts/install_BTT_license.sh

after-dropbox-syncs-common-prefs:
	zsh scripts/after_dropbox_syncs_common_prefs.sh

apps-that-launch-on-login:
	zsh scripts/apps_that_launch_on_login.sh

reset-state:
	zsh scripts/reset_state.sh

defaults-detective:
	zsh scripts/defaults_detective.sh

dev-update-repo-and-submodule:
	git pull --recurse-submodules origin main
	git submodule update --remote
	git add external/genomac-shared
	git diff --cached --quiet external/genomac-shared || git commit -m "Update genomac-shared submodule"
	git push origin main

