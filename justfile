# For syntax/behavior of just, see https://github.com/casey/just
#
# Use A0-, A1-, … prefixes for recipe names to prioritize their display in the fzf-TUI display.
#
# Use `just --list` to see list of recipes by group.
#
# Use `just --choose` to be presented with an interactive chooser to select the particular recipe

# Set default shell for just to Zsh
set shell := ["zsh", "-c"]

# Typing only 'just' will run this default recipe, displaying interactive chooser.
default:
	@just --choose

# Prevent intra-recipe comments from being echoed to the terminal
set ignore-comments

############### Repo-specific configuration
# This section exists to enable closer reuse of justfile code between GenoMac-system and GenoMac-user.
# The recipes below this section refer to the variables defined immediately below. The definition
# of these variables are repo-specific.
# This allows the repo-specificity to be largely restricted to this section of variable definitions.

genomac_local_dir := env_var('HOME') / '.genomac-user'
genomac_remote_repo := 'GenoMac-user'
genomac_github_owner := 'jimratliff'

genomac_fetch_url := 'https://github.com/' + genomac_github_owner + '/' + genomac_remote_repo + '.git'
genomac_push_url := 'git@github.com:' + genomac_github_owner + '/' + genomac_remote_repo + '.git'

############### Run the Hypervisor

# Run the Hypervisor-User
[group('Hypervisor')]
A1-hypervisor-run:
	zsh scripts/run_hypervisor.sh

############### Repo management WITHOUT GitHub authentication

# Refresh local checkout from origin/main, including submodules
[group('Repo management WITHOUT GitHub authentication')]
A0-repo-refresh-repo-and-module:
    # Refresh local checkout from origin/main, including submodules.
    # Does not require GitHub authentication.
    # WARNING: discards local changes in this managed checkout.
    git -C "{{genomac_local_dir}}" fetch origin main
    git -C "{{genomac_local_dir}}" reset --hard origin/main
    git -C "{{genomac_local_dir}}" submodule update --init --recursive

# Destructively make the local clone match origin/main.
[group('Repo management WITHOUT GitHub authentication')]
repo-conform-local-to-remote:
    # Discards local commits and tracked-file changes.
    # Does not remove untracked files.
    git -C "{{genomac_local_dir}}" fetch origin main
    git -C "{{genomac_local_dir}}" reset --hard origin/main
    git -C "{{genomac_local_dir}}" submodule sync --recursive
    git -C "{{genomac_local_dir}}" submodule update --init --recursive

############### Repo management WITH GitHub authentication
# Below this point, the ability to authenticate with GitHub is required

# Update repo/submodule, push → GitHub
[group('Repo management WITH GitHub authentication')]
A2-dev-update-repo-and-submodule:
    # The git diff check detects whether there are staged changes to the
    # submodule and, if so, commits them.
    git -C "{{genomac_local_dir}}" pull --recurse-submodules origin main
    git -C "{{genomac_local_dir}}" submodule update --remote
    git -C "{{genomac_local_dir}}" add external/genomac-shared
    git -C "{{genomac_local_dir}}" diff --cached --quiet external/genomac-shared || git -C "{{genomac_local_dir}}" commit -m "Update genomac-shared submodule"
    git -C "{{genomac_local_dir}}" push origin main

# Configure remote for HTTPS fetch and SSH push 
[group('Repo management WITH GitHub authentication')]
dev-configure-remote-for-https-fetch-and-ssh-push:
    # Sets the fetch URL to HTTPS
    # Sets the push URL to SSH, using the 1Password SSH agent
    git -C "{{genomac_local_dir}}" remote set-url origin "{{genomac_fetch_url}}"
    git -C "{{genomac_local_dir}}" remote set-url --push origin "{{genomac_push_url}}"
    git -C "{{genomac_local_dir}}" config pull.rebase false

############### Verify SSH configuration

[group('SSH agent')]
ssh-agent-verify:
	zsh scripts/utilities/verify_ssh_agent_setup.sh

############### Defaults Detective

[group('Defaults Detective')]
defaults-detective:
	zsh scripts/utilities/defaults_detective.sh

############### User state utilities

[group('State utilities')]
user-states command:
    zsh scripts/utilities/user_state_utilities.sh '{{command}}'

# Show directory containing state files
[group('State utilities')]
user-states-show:
    just user-states show

# Clear SESH state files
[group('State utilities')]
user-states-clear-session-states:
    just user-states clear-session

# DEPRECATED BELOW COMMAND because too easy/dangerous to trigger accidentally
# given there’s no real use case for it.
# [group('State utilities')]
# user-states-clear-all-states:
#     just user-states clear-all

############### Logging utilities

[group('Log file utilities')]
logging command:
    zsh scripts/utilities/logging_utilities.sh '{{command}}'

# Show latest GenoMac-system log file
[group('Log file utilities')]
logging-show-latest:
    just logging show-latest

# Show directory holding GenoMac-system log files
[group('Log file utilities')]
logging-show-directory:
    just logging show-directory








