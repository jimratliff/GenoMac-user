# For syntax/behavior of just, see https://github.com/casey/just

# use `just --choose` to be presented with an interactive chooser to select the particular recipe

# Typing only 'just' will run this default recipe, displaying interactive chooser.
default:
	@just --choose


############### Run the Hypervisor

run-hypervisor:
	zsh scripts/run_hypervisor.sh

############### Repo management

genomac_user_dir := env_var('HOME') / '.genomac-user'

# Pull latest changes from origin/main, including any submodule updates. Does not require authenticating with GitHub
refresh-repo-and-module:
	git -C "{{genomac_user_dir}}" pull --recurse-submodules origin main

# Updates genomac-user repo, including genomac-shared submodule, and pushes it back to GitHub
# The git diff check detects whether there are staged changes to the submodule and, if so, commits them.
# Requires authenticating with GitHub (hence the 'dev-' prefix to distinguish from refresh-repo-and-module recipe.
dev-update-repo-and-submodule:
    git -C "{{genomac_user_dir}}" pull --recurse-submodules origin main
    git -C "{{genomac_user_dir}}" submodule update --remote
    git -C "{{genomac_user_dir}}" add external/genomac-shared
    git -C "{{genomac_user_dir}}" diff --cached --quiet external/genomac-shared || git -C "{{genomac_user_dir}}" commit -m "Update genomac-shared submodule"
    git -C "{{genomac_user_dir}}" push origin main

# Configure remote for HTTPS fetch and SSH push
# Sets the fetch URL to HTTPS (no auth needed for public repo)
# Sets the push URL to SSH (uses 1Password SSH agent)
dev-configure-remote-for-https-fetch-and-ssh-push:
    git -C "{{genomac_user_dir}}" remote set-url origin https://github.com/jimratliff/GenoMac-user.git
    git -C "{{genomac_user_dir}}" remote set-url --push origin git@github.com:jimratliff/GenoMac-user.git
    git -C "{{genomac_user_dir}}" config pull.rebase false

############### Verify SSH configuration

verify-ssh-agent:
	zsh scripts/utilities/verify_ssh_agent_setup.sh

############### Defaults Detective

defaults-detective:
	zsh scripts/utilities/defaults_detective.sh


############### User state utilities

user-states command:
    zsh scripts/utilities/user_state_utilities.sh '{{command}}'

user-states-show:
    just user-states show

user-states-clear-session-states:
    just user-states clear-session

user-states-clear-all-states:
    just user-states clear-all

############### Tests

test-recipe:
	echo "Hi, Jim!"







