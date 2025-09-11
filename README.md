# GenoMac-user
- [Quick-reference cheat sheet for occasional maintenance](#quick-reference-cheat-sheet-for-occasional-maintenance)
- [The role of GenoMac-user within the larger Project GenoMac](#the-role-of-genomac-user-within-the-larger-project-genomac)
- [Overview of using this repo to implement the user-scoped settings for a particular user](#overview-of-using-this-repo-to-implement-the-user-scoped-settings-for-a-particular-user)
- [Step-by-step implementation (for a particular user)](#step-by-step-implementation-for-a-particular-user)
- [Remaining configuration steps that have not been (cannot be) automated](#remaining-configuration-steps-that-have-not-been-cannot-be-automated)
- [Known issues](#known-issues)
- [Appendix: Determining the defaults write commands that correspond to desired changes in settings](https://github.com/jimratliff/GenoMac-user/blob/main/README.md#appendix-determining-the-defaults-write-commands-that-correspond-to-desired-changes-in-settings)

## Quick-reference cheat sheet for occasional maintenance
(First time here? Please go to the next major heading, viz., [The role of GenoMac-user within the larger Project GenoMac](#the-role-of-genomac-user-within-the-larger-project-genomac).)

### Refresh local clone
After initial cloning, to pull down subsequent changes to this repository:
```bash
cd ~/.genomac-user
git pull origin main
```

### Re-“stow” the dotfiles

Any changes to existing dotfiles will be pulled down to the local clone as a result of “[Refresh local clone](#refresh-local-clone).” Only if the *structure* of the dotfiles has changed is it necessary to re-“stow” the dotfiles. By a change in structure, I mean the addition or removal of a dotfile or a change in location of a dotfile.

If the *only* changes to the dotfiles are in the contents of existing dotfiles, there is no need to re-“stow” the dotfiles (which the next section explains how to do).

It is possible, however, that the new content of those dotfiles will not take effect until after the user logs out and logs back in.

To re-“stow” the dotfiles (after refreshing the local clone):
```bash
cd ~/.genomac-user
make stow-dotfiles
```

### Reassert user-scoped settings
To reassert the user-scoped settings (in response to any changes in them in this repo) after refreshing the local clone:
```bash
cd ~/.genomac-user
make initial-prefs
```

## The role of GenoMac-user within the larger Project GenoMac
### Context
This public repo, [GenoMac-user](https://github.com/jimratliff/GenoMac-user) implements generic user-level settings for each user on each Mac that is governed by Project GenoMac. 

Generic user-scoped settings are those configuration parameters (a) whose jurisdiction is that of an individual user but (b) whose values are assumed to be common across all users within the GenoMac project. (This guarantees that a person (viz., me) will enjoy a consistent user experience regardless of which user the person is logged in as.[^commonAcrossUsers])

[^commonAcrossUsers]: The set of generic user-scoped settings won’t exhaust all user-scoped settings. Any user is free to choose their own setting for parameters not covered by the generic settings. However, this raises a nuanced distinction. Each Mac has, for example, a USER_VANILLA. Suppose it is desired that USER_VANILLA has a different choice of some setting than all other users. Nevertheless, it could well be advantageous for that setting to be consistent across all Macs in the sense that, every USER_VANILLA shares that same choice, regardless of which Mac they inhabit. When such a case arises, there could be further refactoring of this process so that each user *type* has its own configurations that would be overlain on the common-across-all-users generic settings. This possibility would apply whether the parameter at issue (a) was not part of the set of generic settings or (b) is covered by, and conflicts with, the prescriptions of the generic settings. In the latter case, applying USER_VANILLA’s choices *after* the generic settings would have the effect of overriding for USER_VANILLA the generic settings.

The current repo is used in conjunction with the [GenoMac-system repo](https://github.com/jimratliff/GenoMac-system), which (a) is cloned exclusively by USER_CONFIGURER and (b) is responsible for configurations at the system level, i.e., that affect all users. This includes, among other things, certain systemwide settings, installing all CLI and GUI apps (both on or off the Mac App Store), and the creation of additional users.

The entire configuration process *for a Mac* begins with the  [GenoMac-system repo](https://github.com/jimratliff/GenoMac-system), *not* with this repo. If you’re starting the configuration of *a new Mac*, start there, and return to this repo only when directed to.

If USER_CONFIGURER of a Mac has already been created and configured and you’re starting to configure an additional user, the current GenoMac-user repo *is* the correct place to start.

### Using this repo as USER_CONFIGURER vis-à-vis any other user
USER_CONFIGURER, like any other user, needs to have its user-scoped settings be configured, and thus uses this repo to do so.

However, the difference in this regard between USER_CONFIGURER and any other user is that USER_CONFIGURER is called upon to use the repo as an intermediate step in implementing its more-ambitious mandate of configuring the entire Mac:
- First, USER_CONFIGURER uses the GenoMac-system repo to set up the Mac from a systemwide perspective, including installing crucial apps and other resources for systemwide use by all users
- USER_CONFIGURER will then clone this repo (GenoMac-user) to its home directory and follow its instructions to configure USER_CONFIGURER’s user-scoped settings.
- USER_CONFIGURER will then return to GenoMac-system to create the additional user accounts for the Mac.
- Then the GenoMac-system repo will direct the iteration through all other users—many of which are newly created by USER_CONFIGURER—where, for each other user, following the instructions of GenoMac-user with respect to that user.

- In contrast, for any user other than USER_CONFIGURER, the current repo is the *starting point* for configuring that user.

### Assumed prerequisites for all users
Before you do anything with this repo, GenoMac-user, the following system-level prerequisites need to have been fulfilled (via the GenoMac-system repo):
- Homebrew, and therefore indirectly, Git, have been installed
- The systemwide PATH has been modified to make all Homebrew-installed apps and man pages available to all users, with no additional user-specific modification of the user’s PATH required
- Terminal and iTerm have both been granted full-disk access by USER-CONFIGURER
- GNU Stow has been installed
- More generally, USER_CONFIGURER has installed
  - all of the third-party apps whose user-specific settings will be specified by GenoMac-user
  - all of the resources (fonts, sounds, screensavers, etc.) that will be referenced by user-specific settings by GenoMac-user

### This repository will be cloned to `~/.genomac-user` of the particular user

This public GenoMac-user repo is meant to be cloned locally (using https[^https]) to each user’s home directory. More specifically, the local directory to which this repo is to be cloned is the hidden directory `~/.genomac-user`, specified by the environment variable $GENOMAC_USER_LOCAL_DIRECTORY (which is exported by the script `assign_environment_variables.sh`).

[^https]: After having cloned the repository via https, GitHub will not let you edit the repo from the CLI (but will from the browser). In order to edit
the repo from the CLI, you would need to change the repo from https to SSH, which can be done via 
`git remote set-url origin git@github.com:OWNER/REPOSITORY.git`. (Use `git remote -v` to clarify the syntax for your repo.)

### This repo supplies the dotfiles that that help to configure some of the user’s software

This repository is intended to be used with [GNU Stow](https://www.gnu.org/software/stow/), which is installed by the GenoMac-system repo.

The `stow_directory` of the current repo contains a set of *dotfiles* for the user that are compartmentalized by “package,” e.g., git, ssh, zsh, etc., and, within each package, the directory structure mimics where the symlinks pointing to these files will reside relative to the user’s $HOME directory. (E.g., `stow_directory/git/.config/git/conf` is the target of a symlink at `~/.config/git/conf`.)

### This repo establishes/adjusts numerous user-level settings
This repo supplies scripts that execute various commands (primarily either `defaults write` or `PlistBuddy`) to establish various user settings for macOS generally and for certain apps in particular.

For tips about how to figure out what the `defaults write` commands are that correspond to a desired change in user-scoped settings, see “[Appendix: Determining the defaults write commands that correspond to desired changes in settings](https://github.com/jimratliff/GenoMac-user/blob/main/README.md#appendix-determining-the-defaults-write-commands-that-correspond-to-desired-changes-in-settings).”

### The distinction between operations that are (a) purely bootstrap and (b) idempotent and therefore both bootstrap and ongoing maintenance
A purely bootstrap operation is one that is intended to be performed typically only once per user. Examples:
- cloning this repo to the user’s local home directory
- implementing settings that provide a starting point for the user, from which the user is free to add or subtract without fear that those subsequent changes would be overridden by a later maintenance step.
  - For example, establishing the initial toolbar configuration for Preview.app. Initially, the toolbar configuration is created to contains certain elements and exclude certain elements. The user can add or subtract to those (or rearrance the order in which they appear on the toolbar) with the understanding that this script won’t be re-run for that user. (If the script *were* re-run, it would undo any of the changes the user made.

More typical is an idempotent operation that is both bootstreap and ongoing maintenance. This characterizes most of the activities of this repo. Sucn an operation establishes a setting the first time the script is run for the user (acting as a bootstrap operation) but the same script also enforces that setting on subsequent maintenance runs.

### The Makefile is the user’s interface with the functionality of this repo

The `Makefile` provides the interface for the user to effect the functionalities of this repo, such as commanding the execution of (a) “stowing” the dotfiles and (b) changing the macOS settings using `defaults write` commands.

## Overview of using this repo to implement the user-scoped settings for a particular user
For each user:
- For each user other than USER_CONFIGURER (who will already have performed these steps)
  - In Safari, access a pre-defined Google Doc to establish a real-time textual connection to other devices to be used as/if needed for real-time exchange of text, error messages, etc.
  - Clone this repo to the user’s home directory in `~/.genomac-user`
- Dotfiles
    - From `~/.genomac-user`, execute `make stow-dotfiles`
    - Log out and log back in
- macOS settings
    - From `~/.genomac-user`, execute `make initial-prefs`
    - Log out and log back in
- Integrate 1Password’s SSH agent with SSH, allowing the user to authenticate with GitHub via the terminal

## Step-by-step implementation (for a particular user)

### Establish real-time connection to communicate text back and forth
(NOTE: USER_CONFIGURER will have already performed this step.)

Open a Google Docs document to be used as/if needed for real-time exchange of text, error messages, etc., between the target Mac and other devices.
- In Safari
  - sign into my standard Google account:
    - Go to google.com and click “Log in”
    - Enter the username of my Google account
    - A QR code will appear. Scan it with my iPhone and complete the authentication.
  - Open the Google Doc document “[Project GenoMac: Text-exchange Document](https://docs.google.com/document/d/1RCbwjLHPidxRJJcvzILKGwtSkKpDrm8dT1fgJxlUdZ4/edit?usp=sharing)]”

### Cloning this repo
(NOTE: USER_CONFIGURER will have already performed this step.)

For each user, this repo should be cloned to the user’s home directory at `~/.genomac-user`. 

Launch Terminal. Then copy the following code block and paste into Terminal:
```shell
mkdir -p ~/.genomac-user
cd ~/.genomac-user
git clone https://github.com/jimratliff/GenoMac-user.git .
```
**Note the trailing “.” at the end of the `git clone` command.**

### “Stow” the dotfiles
The following `make` command runs the script `stow_dotfiles.sh`. This script “stows” the dotfiles found in `stow_directory` as symlinks in $HOME (or subdirectories of $HOME).

Launch Terminal. Then copy the following code block and paste into Terminal:

```shell
cd ~/.genomac-user
make stow-dotfiles
```
<div align="center"><strong>You will be automatically logged out. Please then log back into this account to continue the configuration.</strong></div>


The dotfile [.zshenv](https://github.com/jimratliff/GenoMac-user/blob/main/stow_directory/zsh/.config/zsh/.zshenv) defines:
- `XDG_CONFIG_HOME` to be `~/.config`. Many other Linux-y programs will respect that value and place their own configuration files in `~/.config`.
- several environment variables that determine where Zsh-related dotfiles live:
  - Zsh configuration files (`ZDOTDIR`): `~/.config/zsh`
  - Zsh history (`HISTFILE`): `~/.local/.state/history`
  - Zsh sessions (`XDG_ZSH_SESSIONS_DIR`): `~/.local/.state/sessions`

More specifically, `stow_dotfiles.sh` relies on a list of packages enumerated in the variable `PACKAGES_LIST` in that script. It iterates through each of those packages and, for each package, stows the dotfiles associated with that package.

Thus, to add the dotfiles for a new package, it is *not* sufficient to add those dotfiles to a new package in `stow_directory` (though this is necessary)! In addition, the name of the package must be added to the space-separated `PACKAGES_LIST` in `stow_dotfiles.sh

### Implement the initial set of macOS-related settings
The next step is to implement settings that aren’t captured by the above dotfiles but instead relate to macOS settings or settings of the built-in GUI apps that come automatically on every Mac.

```shell
cd ~/.genomac-user
make initial-prefs
```
Note: This will produce *pages* of terminal output.

<div align="center"><strong>You will be automatically logged out. Please then log back into this account to continue the configuration.</strong></div>

### Implement the bootstrapping operations
Launch Terminal. Then copy the following code block and paste into Terminal:

```shell
cd ~/.genomac-user
make bootstrap-user
```

Note: At this point in development, it is unclear whether, for each bootstrapping operation, that operation needs to be performed (a) before or (b) after [§ Implement the initial set of macOS-related settings](#implement-the-initial-set-of-macos-related-settings). 

### Configure 1Password for authentication with GitHub
Note:
- The GenoMac-system repo will have installed both 1Password (the GUI app) and 1Password-CLI
- The current repo (GenoMac-user) will previously have deployed dotfiles necessary for the integration of 1Password with GitHub authentication.

#### Log into your 1Password account.
Launch 1Password and/or make it active.

Log into my 1Password account. The best way to do this is:
- When you launch the desktop 1Password app for the first time, it will prominently display a "Sign in" button. Click that. It will display a sign-in dialog box, including a QR code you can use to make the sign-in process quicker.
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
    - Do **not** check “Generate SSH config file with bookmarked hosts”

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

## Remaining configuration steps that have not been (cannot be) automated
- macOS interface stuff
  - Set the screensaver to Matrix
  - The `defaults` command to enable “Play feedback when volume is changed” doesn’t always work: though the switch as Settings » Sound » Play feedback when volume is changed is successfully enabled, it doesn't necessarily actually cause feedback when volume is changed. You may need to toggle this off and then back on for it to work.
- Applications
  - Firefox can’t be configured via scripts. Its settings must be implemented manually.
  - Brave Browser can’t be significantly configured via scripts. Its settings must be implemented manually.
 
## Known issues
- Matrix screensaver and hot-corner activation of screen saver
  - Under macOS Tahoe 26 Release Candidate, Matrix screen saver is not working at all, whether triggered by hot-corner activation or by the passage of time.
    - To be clear, the screen *does* darken upon either of these triggers, but the Matrix screen saver display is not shown.
    - The Matrix screen saver display *does* appear in Settings » Wallpaper » Screen Saver…
    - Other, built-in screen savers *do* behave correctly.

## Appendix: Determining the `defaults write` commands that correspond to desired changes in settings
The following addresses how to figure out what `defaults write` commands to add to the scripts in this repository (i.e., the ones reached via `make initial_prefs`) that correspond to changes in user-scoped settings.

This repo contains a script that helps you figure out what `defaults write` commands to add to the scripts in this repository to achieve a desired change in user-scoped settings.

(Note that the referenced script will *not* find the changed settings for *system-wide* commands, because those are located at `/Library/Preferences` rather than `~/Library/Preferences`.)

### Running the “detective script”
Suppose you want to find the `defaults write` command(s) that correspond to particular change(s) in the settings for Application X:
- `cd ~/.genomac-user`
- Launch Application X
- Open the Settings for Application X, but do not yet make the desired changes
- In the terminal, type `make defaults-detective`, which will launch the script `defaults_detective.sh`, which will:
    - record a snapshot of the *pre-change* state of your user’s entire `defaults` plists
    - tell you to that it is ready for you to make the desired changes to the application’s settings
- In Application X, make the desired settings to the application’s settings
- In the terminal, hit *any key* to tell the script that you have finished making the desired changes to settings
- The script will then:
    - record a snapshot of the *post-change* state of your user’s entire `defaults` plists
    - compute and present to you two “diffs” of the two states, which will highlight the changes in the user’s `defaults` plists that occurred between the pre-change and post-change snapshots
        - the first diff reflects changes in the user-scoped settings that are *not* specific to a host, i.e., these would correspond to `defaults write` commands that do *not* include the `-currentHost` switch
        - the second diff reflects changes in the user-scoped settings that *are* specific to the current host, i.e., these would correspond to `defaults write -currentHost` commands
     
### Using the output to construct `defaults write` commands
Each of the two diffs will highlight changes to one or more *keys* in your user’s defaults.

In many cases, the surrounding context in the diff’s output will be too limited to see the *domain* to which the changed key belongs. To find the domain to which a changed key belongs, it is helpful to use either:
```shell
defaults find *key*
```
or
```shell
defaults -currentHost find *key*
```
depending on whether the changed key showed up in the first diff or the second diff, respectively.

When a *key* belonging to a *domain* changes between the pre-change and post-change snapshots, there are two cases:
- the domain/key pair did not appear in the pre-change snapshot but did appear in the post-change snapshot
- the domain/key pair appeared in both the pre-change and post-change snapshots, with different values
In either case, you’ll be interested in the value associated with the domain/key pair in the post-change snapshot.

Although the diff will show you the *value* of the domain/key pair, it will not explicitly show the *type* of that value. To find the type, use one of:
```shell
defaults read-type *domain* *key*
defaults -currentHost read-type *domain* *key*
```

Then you can construct the ultimate command, either of:
```shell
defaults write *domain* *key* *type* *value*
defaults -currentHost write *domain* *key* *type* *value*
```
where *type* could be, for example, `-bool`, `-str`, or `-int`.

### Caveats
- Not every key change actually corresponds to the change in settings. Some changes in key will be inconsequential/irrelevant. You’ll need judgement to know to ignore them.
- Not every change in settings will correspond to a key that can be reached with a simple-form `defaults write`. Instead, a change in settings might result in changes deeper than a simple-form `defaults write` can replicate.


