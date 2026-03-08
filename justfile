# For syntax/behavior of just, see https://github.com/casey/just

# use `just --choose` to be presented with an interactive chooser to select the particular recipe

# Typing only 'just' will run this default recipe, displaying interactive chooser.
default:
	@just --choose


# Run the Hypervisor
run-hypervisor:
	zsh scripts/run_hypervisor.sh

test-recipe:
	echo "Hi, Jim!"

# Pull latest changes from origin/main, including any submodule updates. Does not require authenticating with GitHub
refresh-repo-and-module:
	git -C ~/.genomac-user pull --recurse-submodules origin main

defaults-detective:
	zsh scripts/utilities/defaults_detective.sh

verify-ssh-agent:
	zsh scripts/utilities/verify_ssh_agent_setup.sh

# Updates genomac-user repo, including genomac-shared submodule, and pushes it back to GitHub
dev-update-repo-and-submodule:
    # git diff… checks whether there are staged changes to the submodule and, if so, commits them
    # Requires authenticating with GitHub (hence the 'dev-' prefix to distinguish from refresh-repo-and-module recipe.
    git pull --recurse-submodules origin main
    git submodule update --remote
    git add external/genomac-shared
    git diff --cached --quiet external/genomac-shared || git commit -m "Update genomac-shared submodule"
    git push origin main

# Configure remote for HTTPS fetch and SSH push
dev-configure-remote-for-https-fetch-and-ssh-push:
    # Sets the fetch URL to HTTPS (no auth needed for public repo)
    # Sets the push URL to SSH (uses 1Password SSH agent)
    git remote set-url origin https://github.com/jimratliff/GenoMac-user.git
    git remote set-url --push origin git@github.com:jimratliff/GenoMac-user.git
    git config pull.rebase false
