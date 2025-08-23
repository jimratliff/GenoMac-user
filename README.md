# GenoMac-user
## Overview
This public repo, [GenoMac-user](https://github.com/jimratliff/GenoMac-user) implements generic user-level settings for each user on each Mac that is governed by Project GenoMac. 

Generic user-scoped settings are those configuration parameters (a) whose jurisdiction is that of an individual user but (b) whose values are assumed to be common across all users within the GenoMac project. (This guarantees that a person (viz., me) will enjoy a consistent user experience regardless of which user the person is logged in as.)

The current repo is used in conjunction with the [GenoMac-system repo](https://github.com/jimratliff/GenoMac-system), which (a) is cloned exclusively by USER_CONFIGURER and (b) is responsible for configurations at the system level, i.e., that affect all users. This includes, among other things, certain systemwide settings, installing all CLI and GUI apps (both on or off the Mac App Store), and the creation of additional users.

### Assumed prerequisites
Before you do anything with this repo, GenoMac-user, the following system-level prerequisites need to be fulfilled (via the GenoMac-system repo):
- Homebrew, and therefore indirectly, Git, have been installed
- GNU Stow has been installed

### Clone this respository to `~/.genomac-user` of the particular user

This public GenoMac-user repo is meant to be cloned locally (using https) to each user’s home directory. More specifically, the local directory to which this repo is to be cloned is the hidden directory `~/.genomac-user`, specified by the environment variable $GENOMAC_USER_LOCAL_DIRECTORY (which is exported by the script `assign_environment_variables.sh`).

### This repo supplies the dotfiles that configure some of the user’s software

This repository is intended to be used with [GNU Stow](https://www.gnu.org/software/stow/), which is installed by the GenoMac-system repo.

The `stow_directory` of the current repo contains a set of *dotfiles* for the user that are compartmentalized by “package,” e.g., git, ssh, zsh, etc., and, within each package, the directory structure mimics where the symlinks pointing to these files will reside relative to the user’s $HOME directory. (E.g., `stow_directory/git/.config/git/conf` is the target of a symlink at `~/.config/git/conf`.)

### This repo establishes/adjusts numerous user-level preferences
This repo supplies scripts that execute `defaults write` commands to establish various user preferences for macOS generally and for certain apps in particular.

### The Makefile is the user’s interface with the functionality of this repo

The `Makefile` provides the interface for the user to effect the functionalities of this repo, such as commanding the execution of (a) “stowing” the dotfiles and (b) changing the macOS preferences using `defaults write` commands.

## Implementation (for a particular user)
### Preview
The entire configuration process begins with the  [GenoMac-system repo](https://github.com/jimratliff/GenoMac-system), *not* with this repo. Start there, and return to this repo only when directed to.

#### Highest-level preview
As a global, highest-level preview:
- As part of the initial bootstrapping process of a new Mac, GenoMac-system will direct you to clone this repo (GenoMac-user) to USER_CONFIGURER’s home directory.
- After setting up USER_CONFIGURER’s user-level settings, you’ll return to GenoMac-system to create the additional user accounts for the Mac.
- Then the GenoMac-system repo will direct you to iterate through all other users—many of which are newly created by USER_CONFIGURER—where, for each other user, you will follow the instructions of GenoMac-user with respect to that user.

#### Preview of using this repo to configure any single user
For each user:
- Grant Terminal full-disk access
- Clone this repo to the user’s home directory in `~/.genomac-user`
- Dotfiles
    - From `~/.genomac-user`, execute `make stow-dotfiles`
    - Log out and log back in
- macOS preferences
    - From `~/.genomac-user`, execute `make initial-prefs`
    - Log out and log back in
- Integrate 1Password’s SSH agent with SSH, allowing the user to authenticate with GitHub via the terminal
    
### Grant Terminal full-disk access
- System Settings
  - Privacy & Security
    - Select the Privacy tab
      - Scroll down and click Full Disk Access
        - Enable for Terminal

### Cloning this repo
For each user, this repo should be cloned to the user’s home directory at `~/.genomac-user`. Copy the following code block and paste into Terminal:
```shell
mkdir -p ~/.genomac-user
cd ~/.genomac-user
git clone https://github.com/jimratliff/GenoMac-user.git .
```
**Note the trailing “.” at the end of the `git clone` command.**

### “Stow” the dot files
The following `make` command runs the script `stow_dotfiles.sh`. This script “stows” the dotfiles found in `stow_directory` as symlinks in $HOME (or subdirectories of $HOME):

```shell
cd ~/.genomac-user
make stow-dotfiles
```

Now **log out and log back in as this user**. (This may not be necessary, but it helps remove uncertainty and reduces the possibility of any problems.)`.

The dotfile [.zshenv]
(https://github.com/jimratliff/GenoMac-user/blob/main/stow_directory/zsh/.config/zsh/.zshenv) defines
- `XDG_CONFIG_HOME` to be `~/.config`. Many other Linux-y programs will respect that value and place their own configuration files in `~/.config`.
- several environment variables that determine where Zsh-related dotfiles live:
  - Zsh configuration files: `~/.config/zsh`
  - Zsh history: `~/.local/.state/history`
  - Zsh sessions: `~/.local/.state/sessions`

More specifically, `stow_dotfiles.sh` relies on a list of packages enumerated in the variable `PACKAGES_LIST` in that script. It iterates through each of those packages and, for each package, stows the dotfiles associated with that package.

Thus, to add the dotfiles for a new package, it is *not* sufficient to add those dotfiles to a new package in `stow_directory` (though this is necessary)! In addition, the name of the package must be added to the space-separated `PACKAGES_LIST` in `stow_dotfiles.sh

### Implement the initial set of macOS-related preferences
The next step is to implement preferences that aren’t captured by the above dot files but instead relate to macOS settings or settings of the built-in GUI apps that come automatically on every Mac.

```shell
cd ~/.genomac-user
make initial-prefs
```
Note: This will produce *pages* of terminal output.

### Configure 1Password for authentication with GitHub
Note:
- The GenoMac-system repo will have installed both 1Password (the GUI app) and 1Password-CLI
- The current repo (GenoMac-user) will previously have deployed dotfiles necessary for the integration of 1Password with GitHub authentication.

#### Log into your 1Password account.
Launch 1Password and/or make it active.

Log into my 1Password account. The best way to do this is:
- When you launch the desktop 1Password app for the first time, it will prominently display a "Sign in" button. Click that. It will display a sign-in dialog box, including a QR code you can optionally use to make the sign-in process quicker.
- Get your iPhone.
  - Launch 1Password on iPhone
  - From the 1Password logo in the upper-left corner of the 1Password app on iPhone, select “Scan QR Code…”
  - Follow the instructions

#### Adjust settings of 1Password
Make 1Password active.

##### Make 1Password persistent
(Note: The two checkboxes below may indeed be turned on by default, as desired.)

In the 1Password app, turn on two checkboxes to ensure that 1Password’s SSH Agent will be live even if the 1Password app itself is closed.
- 1Password » Settings » General
  - ✅ Keep 1Password in the menu bar
  - ✅ Start 1Password at login
 
##### Enable 1Password SSH Agent
Again in the 1Password app:
- 1Password » Settings » Developer:
  - Click on "Setup SSH Agent"
    - SSH Agent
      - ✅ Use the SSH Agent
      - You will see a dialog box “Allow 1Password to save SSH key names to disk?”
      - Click the default “Use Key Names” button
    - Advanced
      - Remember key approval: **until 1Password quits**
  - Command-Line Interface (CLI)
    - ✅ Integrate with 1Password CLI
      - I don’t know much about this, but it seems like a good idea.
      - (“Use the desktop app to sign in to 1Password in the terminal.”)

#### Test the SSH connection with GitHub
```shell
cd ~/.genomac-user
make verify-ssh-agent
```

You will see:
```
🪚 Testing SSH auth with: ssh -T git@github.com
The authenticity of host 'github.com (140.82.116.4)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```
Type yes. Then 1Password will present a dialog allowing you to authorize.

If successful, you will see:
```
🪚 Testing SSH auth with: ssh -T git@github.com
✅ SSH authentication with GitHub succeeded
Verified: SSH agent is working
```
