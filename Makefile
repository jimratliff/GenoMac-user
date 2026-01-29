# --------------------------------------------------------------------
# Phony targets (not real files)
# --------------------------------------------------------------------
.PHONY: \
	after-dropbox-syncs-common-prefs \
	apps-that-launch-on-login \
	bootstrap-user \
	btt-license \
	defaults_detective \
	dev-update-repo-and-submodule \
	execute_one_time_per_user \
	initial-prefs \
	reset-state \
	run-hypervisor \
	sign-in-to-selected-apps \
	stow-dotfiles \
	test-launch-and-prompt \
	test-refactor \
	test-state-management \
	verify-ssh-agent \

# --------------------------------------------------------------------
# Targets
# --------------------------------------------------------------------

run-hypervisor:
	zsh scripts/run_hypervisor.sh

refresh-repo:
	git -C ~/.genomac-user pull --recurse-submodules origin main

defaults-detective:
	zsh scripts/utilities/defaults_detective.sh

test-launch-and-prompt:
	zsh scripts/test_launch_and_prompt.sh

test-refactor:
	zsh scripts/test_refactor.sh

test-state-management:
	zsh scripts/test_state_management.sh

test-show-with-quicklook:
	zsh scripts/test_show_with_quicklook.sh

verify-ssh-agent:
	zsh scripts/verify_ssh_agent_setup.sh

reset-state:
	zsh scripts/reset_state.sh

dev-prep-keyboard-maestro-for-experiments:
	zsh scripts/dev_prep_keyboard_maestro_for_experiments.sh


## Updates genomac-user repo, including genomac-shared submodule, and pushes it back to GitHub
## git diff… checks whether there are staged changes to the submodule and, if so, commits them
dev-update-repo-and-submodule:
	git pull --recurse-submodules origin main
	git submodule update --remote
	git add external/genomac-shared
	git diff --cached --quiet external/genomac-shared || git commit -m "Update genomac-shared submodule"
	git push origin main

# Configure remote for HTTPS fetch and SSH push
# Sets the fetch URL to HTTPS (no auth needed for public repo)
# Sets the push URL to SSH (uses 1Password SSH agent)
dev-configure-remote-for-https-fetch-and-ssh-push:
	cd ~/.genomac-user
	git remote set-url origin https://github.com/jimratliff/GenoMac-user.git
	git remote set-url --push origin git@github.com:jimratliff/GenoMac-user.git

