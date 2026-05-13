# For syntax/behavior of just, see https://github.com/casey/just

# use `just --choose` to be presented with an interactive chooser to select the particular recipe

# Typing only 'just' will run this default recipe, displaying interactive chooser.
default:
	@just --choose


############### Run the Hypervisor

run-hypervisor:
	zsh scripts/run_hypervisor.sh

############### Repo-specific configuration
genomac_local_dir := env_var('HOME') / '.genomac-user'
genomac_remote_repo := 'GenoMac-user'
genomac_github_owner := 'jimratliff'

genomac_fetch_url := 'https://github.com/' + genomac_github_owner + '/' + genomac_remote_repo + '.git'
genomac_push_url := 'git@github.com:' + genomac_github_owner + '/' + genomac_remote_repo + '.git'

############### Repo management

# Pull latest changes from origin/main, including any submodule updates. Does not require authenticating with GitHub
refresh-repo-and-module:
    git -C "{{genomac_local_dir}}" pull --recurse-submodules origin main

# Updates this repo, including genomac-shared submodule, and pushes it back to GitHub
# The git diff check detects whether there are staged changes to the submodule and, if so, commits them.
# Requires authenticating with GitHub (hence the 'dev-' prefix to distinguish from refresh-repo-and-module recipe).
dev-update-repo-and-submodule:
    git -C "{{genomac_local_dir}}" pull --recurse-submodules origin main
    git -C "{{genomac_local_dir}}" submodule update --remote
    git -C "{{genomac_local_dir}}" add external/genomac-shared
    git -C "{{genomac_local_dir}}" diff --cached --quiet external/genomac-shared || git -C "{{genomac_local_dir}}" commit -m "Update genomac-shared submodule"
    git -C "{{genomac_local_dir}}" push origin main

# Configure remote for HTTPS fetch and SSH push
# Sets the fetch URL to HTTPS
# Sets the push URL to SSH, using the 1Password SSH agent
dev-configure-remote-for-https-fetch-and-ssh-push:
    git -C "{{genomac_local_dir}}" remote set-url origin "{{genomac_fetch_url}}"
    git -C "{{genomac_local_dir}}" remote set-url --push origin "{{genomac_push_url}}"
    git -C "{{genomac_local_dir}}" config pull.rebase false

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







