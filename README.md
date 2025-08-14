# GenoMac-user
## Overview
This public repo, GenoMac-user, is used in conjunction with the [GenoMac-system repo](https://github.com/jimratliff/GenoMac-system). [The GenoMac-system repo is cloned exclusively by USER_CONFIGURER. GenoMac-system is responsible for configurations at the system level, i.e., that affect all users. This includes, among other things, installing all CLI and GUI apps (both on or off the Mac App Store).]

This repo, in contrast, is focused on generic user-specific settings, in other words settings (a) whose jurisdiction is that of an individual user but (b) which are assumed to be the same across all users within the GenoMac project. (This guarantees that a person (viz., me) will enjoy a consistent user experience regardless of which user the person is logged in as.)

### Assumed prerequisites
Before you do anything with this repo, GenoMac-user, the following system-level prerequisites need to be fulfilled (via the GenoMac-system repo):
- Homebrew, and therefore indirectly, Git, have been installed
- GNU Stow has been installed

### Cloned to `~/.genomac-user` of each user

This public GenoMac-user repo is meant to be cloned locally (using https) to each user’s home directory to support the configuration of that user’s account, applications, etc. More specifically, the local directory to which this repo is to be cloned is the hidden directory `~/.genomac-user`, specified by the environment variable $GENOMAC_USER_LOCAL_DIRECTORY (which is exported by the script `assign_environment_variables.sh`).

### This repo supplies the “dot files” that configure some of the user’s software

This repository is intended to be used with [GNU Stow](https://www.gnu.org/software/stow/), which is installed by the GenoMac-system repo.

The `stow_directory` of the current repo contains a set of “dot files” for the user that are compartmentalized by “package,” e.g., git, ssh, zsh, etc. and, within each package, the directory structure mimics where the symlinks pointing to these files will reside in the user’s $HOME directory. (E.g., `stow_directory/git/.config/git/conf` is the target of the symlink at `~/.config/git/conf`.)

### This repo supplies scripts that execute `defaults write` commands to establish various user preferences for macOS generally and for certain apps in particular

[TO BE WRITTEN]

### The Makefile is the user’s interface with the functionality of this repo

The `Makefile` provides the interface for the user to command the execution of (a) “stowing”
the dot files and (b) changes the macOS preferences using `defaults write` commands.

[TO BE WRITTEN]

## Implementation (for a particular user)
### Preview
The entire configuration process begins with the GenoMac-system repository, *not* with this repo. Start there, and return to this repo only when directed to.

As a preview:
- As part of the initial bootstrapping process, GenoMac-system will direct you to clone this repo (GenoMac-user) to USER_CONFIGURER’s home directory.
- After the system-level configuration bootstrapping is completed, GenoMac-system will then direct you to iterate through all other users where, for each other user, you will follow the instructions of GenoMac-user
with respect to that user.

For each user:
- Grant Terminal full-disk access
- Clone this repo to the user’s home directory
- Dot files
    - From `~/.genomac-user`, execute `make stow-dotfiles`
    - Log out and log back in
- macOS preferences
    - From `~/.genomac-user`, execute `make initial-prefs`
    - Log out and log back in
- TODO: Integrate 1Password’s SSH agent with SSH
    
### Grant Terminal full-disk access
- System Settings
  - Privacy & Security
    - Select the Privacy tab
      - Scroll down and click Full Disk Access
        - Enable for Terminal

### Cloning this repo
For each user, this repo should be cloned to the user’s home directory at `~/.genomac-user`:

```shell
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

Now **log out and log back in as this user**. (This may not be necessary, but it helps remove uncertainty and reduces the possibility of any problems.)


More specifically, `stow_dotfiles.sh` relies on a list of packages enumerated in the variable `PACKAGES_LIST` in that script. It iterates through each of those packages and, for each package, stows the dotfiles associated with that package.

Thus, to add the dotfiles for a new package, it is *not* sufficient to add those dotfiles to a new package in `stow_directory` (though this is necessary)! In addition, the name of the package must be added to the space-separated `PACKAGES_LIST` in `stow_dotfiles.sh`.

### Implement the initial set of macOS-related preferences
The next step is to implement preferences that aren’t captured by the above dot files but instead relate to macOS settings or settings of the built-in GUI apps that come automatically on every Mac.

```shell
cd ~/.genomac-user
make initial-prefs
```
Note: This will produce *pages* of terminal output.