# GenoMac-user
- [Quick-reference cheat sheet for occasional maintenance](#quick-reference-cheat-sheet-for-occasional-maintenance)
- [The role of GenoMac-user within the larger Project GenoMac](#the-role-of-genomac-user-within-the-larger-project-genomac)
- [Overview of using this repo to implement the user-scoped settings for a particular user](#overview-of-using-this-repo-to-implement-the-user-scoped-settings-for-a-particular-user)
- [Step-by-step implementation (for a particular user)](#step-by-step-implementation-for-a-particular-user)
- [Remaining configuration steps that have not been (cannot be) automated](#remaining-configuration-steps-that-have-not-been-cannot-be-automated)
- [TODOs](#todos)
- [Known issues](#known-issues)
- [Dev issues](#appendix-dev-issues)
- [Appendix: Compilation of selected settings choices (NOT exhaustive!)](#appendix-compilation-of-selected-settings-choices-not-exhaustive)
- [Appendix: Determining the defaults write commands that correspond to desired changes in settings](#appendix-determining-the-defaults-write-commands-that-correspond-to-desired-changes-in-settings)
- [Appendix: What to do when you change the BetterTouchTool preset](#appendix-what-to-do-when-you-change-the-bettertouchtool-preset)

## Quick-reference cheat sheet for occasional maintenance
(First time here? Please go to the next major heading, viz., [The role of GenoMac-user within the larger Project GenoMac](#the-role-of-genomac-user-within-the-larger-project-genomac).)

The remainder of this section assumes you’ve already locally cloned the GenoMac-user repository to `~/.genomac-user` and that you’ve run the Hypervisor once completely through.

Project GenoMac-user does *not* require regular maintenance. Once you’ve configured a particular user account the first time, that should do it—*unless something changes*. See [When to run the Hypervisor](#when-to-run-the-hypervisor) for a discussion of what kinds of changes warrant some kind of action on your part.

### Refresh local clone
Every time you run the Hypervisor, it will check the remote of GenoMac-user on GitHub to determine whether there are changes relative to the local copy and, if so, will pull those down.

Alternatively, you can do that check-and-update yourself with:[^git_pull_interpretation]
```bash
cd ~/.genomac-user
just refresh-repo-and-module
```
[^git_pull_interpretation]: This `just` recipe is just a shorthand for `git pull --recurse-submodules origin main`. The `--recurse-submodules` ensures that the local version of submodule GenoMac-shared is updated to the commit specified by the GenoMac-user origin repository.

### Running the Hypervisor
The Hypervisor is a scripting system that manages the configuration of the user, both (a) for the initial bootstrap and (b) for periodic maintenance.

The Hypervisor is run by:
```
cd ~/.genomac-user
just run-hypervisor
```

At certain points in the process, the Hypervisor will force a logout. When you log in after the logout, simply start the Hypervisor again (`just run-hypervisor`). The Hypervisor keeps track of its state, and it will restart where you last left off. Keep logging back in, after each logout, and running `just run-hypervisor` until you see:
```
 _____  _____  _____  _   _  _
|_   _||_   _||  ___|| \ | || |
  | |    | |  | |_   |  \| || |
  | |    | |  |  _|  | |\  ||_|
  |_|    |_|  |_|    |_| \_|(_)


ℹ️  You will be logged out semi-automatically to fully internalize all the work we’ve done.
   Please log back in.
   To restart, re-execute just run-hypervisor and we’ll pick up where we left off.

✅ No GenoMac warnings or failures detected in this run.
```

### When to run the Hypervisor
The very first time the Hypervisor is run for a particular user account, that user’s local settings will be established based on what the Hypervisor believed at that time to be the desired configuration.

In normal operation, then, there’s no reason to rerun the Hypervisor unless something changes. The below discusses what kind of changes would warrant rerunning the Hypervisor.
#### If the dotfiles change…
If you make changes to the dotfiles stored in `GenoMac-user/stow_directory`, whether or not to re-run the Hypervisor depends on whether (a) only the contents of existing dotfiles have changed or (b) there’s a change in the *structure* of the dotfiles.
##### If only the *contents* of one or more *existing* dotfiles change
If the only changes to your dotfiles are the *contents* of one or more *existing* dotfiles, it’s sufficient to (a) refresh the local repo (see [Refresh local clone](#refresh-local-clone)), which will update the dotfiles on local disk, and (b) log out of the user account and log back in.
##### If the *structure* of the dotfiles changes
In contrast, if the *structure* of the dotfiles changes, run the Hypervisor.

A change in the structure of the dotfiles would be any combination of (a) adding a new package or removing a package (for example, if you add a new terminal app, such as Kitty or Ghostty, and adds its dotfiles to stow_directory), (b) adding a new file or directory to an existing package’s dotfiles, or (c) in any other way modify the file structure of stow_directory. Running Hypervisor will run `stow`, which will properly remap symlinks to reflect the changes in structure. (In other words, `stow` doesn’t care what’s *in* each *file* in `stow_directory`, but it does care about the file and directory structure of `stow_directory`.)

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

GenoMac-user also relies (as does GenoMac-system) on the [GenoMac-shared repository](https://github.com/jimratliff/GenoMac-shared). GenoMac-shared is an externally defined set of common code that specifies some environment variables and defines some helper functions. This common code is incorporated into each of GenoMac-user and GenoMac-system as a submodule located at `external/genomac-shared` of each of the two container repositories. (See GenoMac-shared’s [README](https://github.com/jimratliff/GenoMac-shared/blob/main/README.md) for information on how that affects/complicates work flows, particularly when there is a change to GenoMac-shared’s code.)

The entire configuration process *for a Mac* begins with the  [GenoMac-system repo](https://github.com/jimratliff/GenoMac-system), *not* with this repo. If you’re starting the configuration of *a new Mac*, start there, and return to this repo only when directed to.

If USER_CONFIGURER of a Mac has already been created and configured and you’re starting to configure an additional user, the current GenoMac-user repo *is* the correct place to start.

### Using this repo as USER_CONFIGURER vis-à-vis any other user
USER_CONFIGURER, like any other user, needs to have its user-scoped settings be configured, and thus uses this repo to do so.

However, the difference in this regard between USER_CONFIGURER and any other user is that USER_CONFIGURER has a broader, more-ambitious mandate: configuring the *entire Mac* at the system level and creating the user accounts for all other users:
- First, USER_CONFIGURER uses the GenoMac-system repo to set up the Mac from a systemwide perspective, including installing crucial apps and other resources for systemwide use by all users
- USER_CONFIGURER will then clone this repo (GenoMac-user) to USER_CONFIGURER’s home directory and follow this repo’s instructions to configure USER_CONFIGURER’s user-scoped settings.
- USER_CONFIGURER will then return to GenoMac-system to create the additional user accounts for the Mac.
- Then the GenoMac-system repo will direct you to iterate through all other users—many of which are newly created by USER_CONFIGURER—where, for each other user, you follow the instructions of GenoMac-user with respect to that user.

In contrast, for any user other than USER_CONFIGURER, the current repo is the *starting point* for configuring that user.

### What this repo assumes has already been performed by GenoMac-system
Before you do anything with this repo, GenoMac-user, the following system-level prerequisites need to have been fulfilled (via USER_CONFIGURER using the GenoMac-system repo):
- Homebrew and, therefore indirectly, Git have been installed
- The systemwide PATH has been modified to make all Homebrew-installed apps and man pages available to all users, with no additional user-specific modification of the user’s PATH required
- The following have been installed
  - iTerm
  - GNU Stow
  - certain other utilities required by GenoMac-user (e.g., jq, just, mas)
  - all of the third-party apps whose user-specific settings will be specified by GenoMac-user
  - all of the resources (fonts, sounds, screensavers, etc.) that will be referenced by user-specific settings by GenoMac-user
- iTerm has been granted by USER_CONFIGURER (a) Full Disk Access and (b) control of System Events (in order to run AppleScripts)

### This repository will be cloned to `~/.genomac-user` of the particular user

This public GenoMac-user repo is meant to be cloned locally (using https[^https]) to each user’s home directory. More specifically, the local directory to which this repo is to be cloned is the hidden directory `~/.genomac-user`.

[^https]: After having cloned the repository via https, GitHub will not let you edit the repo from the CLI (but will from the browser, when logged into your GitHub account). In order to edit
the repo from the CLI, you would need to change the repo from https to SSH, which can be done via the command
`just dev-configure-remote-for-https-fetch-and-ssh-push`.

### This repo supplies “dotfiles” that help to configure some of the user’s software

This repository is intended to be used with [GNU Stow](https://www.gnu.org/software/stow/), which is installed by the GenoMac-system repo.

The `stow_directory` of the current repo contains a set of *dotfiles* for the user that are compartmentalized by “package,” e.g., git, ssh, zsh, etc. For example, famous examples of dotfiles are `.zshrc` (for Zshell) and Git’s `config` files.

Within the directory corresponding to each package, the directory structure mimics where the symlinks pointing to these files will reside relative to the user’s $HOME directory. (E.g., `stow_directory/git/.config/git/conf` is the target of a symlink at `~/.config/git/conf`.)

### This repo establishes/adjusts numerous user-level settings
This repo supplies scripts that execute various commands to establish various user settings for macOS generally and for certain apps in particular.

For many/most of the macOS settings and for many/most of the GUI apps, these scripts use macOS `defaults write` or `PlistBuddy` commands to set preferences using macOS `defaults` system.[^find_defaults]

[^find_defaults]: For tips about how to figure out what the `defaults write` commands are that correspond to a desired change in user-scoped settings, see “[Appendix: Determining the defaults write commands that correspond to desired changes in settings](https://github.com/jimratliff/GenoMac-user/blob/main/README.md#appendix-determining-the-defaults-write-commands-that-correspond-to-desired-changes-in-settings).”

Some apps, particularly non-Apple cross-platform apps such as web browsers, don’t rely entirely or at all upon macOS’s `defaults` system but instead use other mechanisms to expose their preferences to scripting. This repo nevertheless attempts to script those apps’ preferences to the extent possible/feasible/practical. Examples of apps in this category:
- Apps whose preferences are stored remotely associated with the user’s account for that app. E.g., Text Expander. This repo relies upon the user logging into their account with such an app to provide the desired configuration.
- Apps based on Electron, which store their settings in JSON configuration files.
- 1Password: 1Password is an Electron-based app and reveals its preferences in a `settings.json` file, which should make it straightforward to manipulate those preferences via scripting. However, presumably driven by a security concern, 1Password makes it impossible to effectively script those preferences.[^1Password_HMAC]
- Microsoft Word: Very few of Word’s preferences are revealed through the macOS `defaults` system. Instead, this repo implements settings for Word by a combination of (a) installing a preconfigured Normal.dotm template file and (b) running a VBA script stored within a Word document to set some Word preferences.

[^1Password_HMAC]: 1Password’s preferences are stored at `~/Library/Group Containers/2BUA8C4S2C.com.1password/Library/Application Support/1Password/Data/settings/settings.json`. Each substantive key-value pair representing a preference is accompanied by an `authTags` key-value pair, with the same key but the value of which is a cryptographic signature. The hashing is unpredictable to me, so I can’t write a script to provide new key-value preference pairs with `authTags` pairs that survive validation.

Some apps require additional steps to authorize the user to execute the app. These call into the following categories:
- Apps that require signing into an account for that app. These include 1Password, Microsoft Office, Text Expander
- Apps that require a license file.
- Apps that require entering a key to authorize.
  - Alfred: Alfred’s basic functionality is free to use, but more-advanced functionality (the Alfred Powerpack) requires entering a Powerpack license. GenoMac-user assumes you will enter a Powerpack license via a Keyboard Maestro status-menu-triggered macro that pastes the Alfred Powerpack textual license code into the appropriate text box in Alfred’s preferences.[^Alfred_key_is_secure]
  - Keyboard Maestro: Because Keyboard Maestro has an initial trial period for every new user account, you can use a Keyboard Maestro macro to register your license to Keyboard Maestro! Specifically, you can use an already-Dropbox-synced Keyboard Maestro status-menu-triggered macro that chooses the “Register Keyboard Macro…” menu item to populate the email-address and serial-number fields with the credentials under which Keyboard Maestro is registered.[^KM_key_is_secure]
 
[^Alfred_key_is_secure]: Note that the Alfred Powerpack license key is *not* stored in this or any other repository. It is stored within the definition of the Keyboard Maestro macro, which itself is stored in a not-publicly-accessible Dropbox-synced file.
[^KM_key_is_secure]: Like the Alfred Powerpack license key, the Keyboard Maestro serial number is *not* stored in this or any other repository. It is stored within the definition of the Keyboard Maestro macro, which itself is stored in a not-publicly-accessible Dropbox-synced file.

### The distinction between operations that are (a) purely bootstrap vis-à-vis (b) idempotent and therefore both bootstrap and ongoing maintenance
A purely bootstrap operation is one that is intended to be performed typically only once per user or perhaps performed again only under exceptional circumstances (e.g., a change in desired settings or an external change in macOS or in third-party software). Examples:
- cloning this repo to the user’s local home directory
- implementing settings that provide a starting point for the user, from which the user is free to add or subtract without fear that those subsequent changes would be overridden by a later maintenance step.
  - For example, establishing the initial toolbar configuration for Preview.app. Initially, the toolbar configuration is created to contain certain elements and exclude certain elements. The user can add or subtract to those (or rearrange the order in which they appear on the toolbar) with the understanding that this script won’t be re-run for that user. (If the script *were* re-run, it could undo some/all of the changes the user made.

More typical is an idempotent operation that is both bootstrap and ongoing maintenance. This characterizes most of the activities of this repo. Sucn an operation establishes a setting the first time the script is run for the user (acting as a bootstrap operation) but the same script also enforces that setting on subsequent maintenance runs.

### The justfile is the user’s interface with the functionality of this repo

The `justfile` provides the interface for the user to effect the functionalities of this repo, such as commanding the execution of “the Hypervisor” that oversees the operation of the user-level settings or refreshing the local copy of the repository.

## Overview of using this repo to implement the user-scoped settings for a particular user
For each user:
- In Safari, access a pre-defined Google Doc to establish a real-time textual connection to other devices to be used as/if needed for real-time exchange of text, error messages, etc.
  - USER_CONFIGURER will already have performed this step as a result of using the repository GenoMac-system.  
- Clone this repo to the user’s home directory in `~/.genomac-user`
- Repeatedly run “the Hypervisor,” which is a script that oversees the execution of the many steps involved in configuring the user’s account.
  - I say repeatedly because the Hypervisor will at various points force/urge the user to logout and log back into the user’s account. After logging back in, the user will once again launch the Hypervisor. The Hypervisor maintains state to know what steps have been completed and which step is the next one to perform.
 
The steps performed/managed by the Hypervisor include:
- “Stow”-ing the user’s dotfiles, which provides configuration for some software (e.g., Git, Zshell, Homebrew, SSH, BetterTouchTool, 1Password’s SSH agent, the Starship terminal prompt, and the Zed editor)
- Setting preferences for the overall macOS interface, some Apple apps (e.g., Safari), and approximately 20 third-party GUI apps.
- Integrating 1Password’s SSH agent with SSH, allowing the user to authenticate with GitHub via the terminal
- Connect to Dropbox for selective file syncing
  - In particular, the user selectively syncs with a particular Dropbox directory containing shared preferences and/or proof of license for certain apps, e.g., BetterTouchTool, Keyboard Maestro, and Witch.
- Microsoft Word: install a preconfigured Normal.dotm file and implement preferences using a VBA macro

While the vast majority of the settings specified by GenoMac-user are implemented entirely via automated scripting, not all steps can be entirely automated. For example:
- Generally, any app that requires signing into an account (e.g., 1Password, Text Expander, Microsoft Word) requires manual intervention by the user
- Some apps require special macOS-level permissions (e.g., Full Disk Access, Accessibility permissions). Apple does not permit these settings to be performed by scripting.
- 1Password: Presumably out of a heightened concern for security, 1Password erects obstacles preventing setting its preferences by scripting. These preferences need to be set manually.
- Configuring certain extensions for the Waterfox browsers requires some manual steps.

Even though the Hypervisor can’t fully automate these operations, the Hypervisor *does* cue you to perform each one, walking you through each of the manual steps, both by (a) launching the relevant app, System Settings panel, or folder and (b) popping up (in a QuickLook window) detailed written instructions to follow for each operation.

## Step-by-step implementation (for a particular user)
- [Establish real-time connection to communicate text back and forth](#establish-real-time-connection-to-communicate-text-back-and-forth)
- [Cloning this repo](#cloning-this-repo)
- [“Stow” the dotfiles](#stow-the-dotfiles)
- [Implement the initial set of macOS-related settings](#implement-the-initial-set-of-macos-related-settings)
- [Run certain one-time-only bootstrapping operations](#run-certain-one-time-only-bootstrapping-operations)
- [Configure 1Password for authentication with GitHub](#configure-1password-for-authentication-with-github)
- [Connect to the user’s Dropbox account and configure apps that rely on Dropbox](#connect-to-the-users-dropbox-account-and-configure-apps-that-rely-on-dropbox)

### Establish real-time connection to communicate text back and forth
(NOTE: USER_CONFIGURER will have already performed this step. Other users will need to do that at this time.)

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
git clone --recurse-submodules https://github.com/jimratliff/GenoMac-user.git .
```
**Note the trailing “.” at the end of the `git clone` command.**

(The `--recurse-submodules` flag exists because this repo has a submodule ([GenoMac-shared](https://github.com/jimratliff/GenoMac-shared)). The `--recurse-submodules` ensures that the submodule’s code is also cloned, not just a pointer to it.)

### Running the Hypervisor
The Hypervisor is a scripting function that manages the configuration of the user, both (a) for the initial bootstrap and (b) for periodic maintenance.

The Hypervisor is run by:
```
cd ~/.genomac-user
just run-hypervisor
```

At certain points in the process, the Hypervisor will force a logout. When you log in after the logout, simply start the Hypervisor again. The Hypervisor keeps track of its state, and it will restart where you last left off.

The Hypervisor produces a *lot* of output, typically many screenfulls. If an important warning is issued, the Hypervisor keeps track of it and redisplays it when it reaches a standard stopping point (either when it urges you to logout or when it completes the entire configuration). If no warnings were detected, the Hypervisor will state that explicitly:
```
✅ No GenoMac warnings or failures detected in this run.
```

By compiling any warnings and repeating them at the end, you’re relieved of the necessity of wading through all of the output to look for anomalies.

Also note that the Hypervisor runs under `set -euo pipefail`, which is designed to make everything come to a crashing halt if there is any error. Thus, it tries to protect you against silent failures that you wouldn’t notice.

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

More specifically, `stow_dotfiles.sh` relies on a list of packages enumerated in the environment variable `GMU_ARRAY_OF_PACKAGES_TO_STOW_DOTFILES`. It iterates through each of those packages and, for each package, stows the dotfiles associated with that package.

Thus, to add the dotfiles for a new package, it is *not* sufficient to add those dotfiles to a new package in `stow_directory` (though this is necessary)! In addition, the name of the package must be added to the space-separated `GMU_ARRAY_OF_PACKAGES_TO_STOW_DOTFILES` in `scripts/assign_user_environment_variables.sh`.

### Implement the initial set of macOS-related settings
The next step is to implement settings that aren’t captured by the above dotfiles such as many macOS settings or settings of the built-in GUI apps that come automatically on every Mac.

```shell
cd ~/.genomac-user
make initial-prefs
```
Note: This will produce *pages* of terminal output.

<div align="center"><strong>You will be automatically logged out. Please then log back into this account to continue the configuration.</strong></div>

### Run certain one-time-only bootstrapping operations
This next step is intended to be executed *only one time per user*. It implements:
- a default configuration of apps in the Dock
- default toolbar configuration for each of Finder and Preview
- register QuickLook plugins[^QL]

[^QL]: It’s possible, but I’m not sure, that a QuickLook plugins needs to be registered only once *per Mac* rather than once per user.

The user is then free to adjust that configuration with no concern that a maintenance/enforcement script will come around and clobber those toolbar changes.

Launch Terminal. Then copy the following code block and paste into Terminal:

```shell
cd ~/.genomac-user
make bootstrap-user
```

It may appear at first that the toolbar changes have not taken effect. It sometimes, mysteriously, takes a few logout/login cycles for the changes to be reflected.

<div align="center"><strong>You will be automatically logged out. Please then log back into this account to continue the configuration.</strong></div>.

This is meant primarily to be a bootstrap step, but it would need to be repeated (or revisited) if there were changes to the Dock/toolbar and/or additional QL plugins. Possibly a migration script would instead be run (to avoid overwriting user customizations).

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
      - Do **not** check “Generate SSH config file with bookmarked hosts”
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

### Connect to the user’s Dropbox account and configure apps that rely on Dropbox
#### Connect to the user’s Dropbox account
- Launch Dropbox
- A splash dialog will invite you to “Sign in with Dropbox”
- Accept the invitation ⇒ A browser window opens: “API Request Authorization - Dropbox”
- A separate dialog asks you to “Turn on accessibility”
  - Follow the instructions to do so: Settings » Accessibility » ✅ Dropbox
- Selectively sync at least:
  - `~/path/to/Dropbox/Preferences_common`
 
#### After Dropbox full syncs `Preferences_common`, execute make command
The following step can be performed only after `~/path/to/Dropbox/Preferences_common` has completely synced with Dropbox:
```shell
cd ~/.genomac-user
make after-dropbox-syncs-common-prefs
```

This command:
- Keyboard Maestro: enables macro syncing
- BetterTouchTool: installs license file
 
### Set apps that will launch automatically when the user logs in
```shell
cd ~/.genomac-user
make apps-that-launch-on-login
```

## Remaining configuration steps that have not been (cannot be) automated
See the Google Docs document “[Project GenoMac: Post-automation steps](https://docs.google.com/document/d/1jKJpWnCBFcT24MGbaeMq90fbnus2rMHIVlRejkfI9aw/edit?usp=sharing)” (in my standard Google account).
 
## TODOs
- Keyboard-navigation hotkeys ⇧⌥⌘F2 – ⇧⌥⌘F7 need to be tested
- Laptop-specific settings
  - To date, my development of Project GenoMac has been performed on a Mac mini. Thus,  I have not been able to experiment with settings that are relevant only on a laptop, such as battery settings.
  - In particular, I should explore the Control Center’s Battery module’s setting.
    - In particular, I believe the legacy mentions of `defaults write com.apple.menuextra.battery ShowPercent -string "NO"` no longer apply.
  - Incorporate new helper function: this_mac_is_a_laptop()
  - Change menubar clock configuration for laptop
  - Change pmset settings for laptop, so that they vary based on battery/charging
- set_power_management_settings.sh
  - Finish, and move to a bootstrapping step
- Finder
  - ✅ Open new window to HOME is meant to be bootstrap only, not maintenance
  - Show hard disks, external drives, connected servers is meant to be different for admin users than for regular users.
- Setting apps “Assign to: All Desktops” requires that there already be multiple Spaces
  - Thus, I need either (a) create at least a second Space early or (b) defer making these assignments until after there are multiple Spaces.
- Assiging wallpapers to Spaces
  - Keyboard Maestro has a “Set Desktop Image” command that, I believe, is limited to the current Space. You could then iterate over Spaces and set the wallpaper.
    - This may not be preferable to AppleScript-ing the entire process.
- set_screen_capture_settings.sh
  - Consider making setting the destination for screenshots be user-specific (or occur after Dropbox sync, in order to save to a Dropbox directory)
- Scripting
  - Main entry-point script: Should check whether there are un-pulled changes to the repo. If so, warn the executing user to refresh the repo.
  - `defaults write`
    - To the extent that all `defaults write` command aren’t in one place (e.g., reversal of defaults re display-disks-on-desktop settings), dynamically build a list of apps to quit. Or is this now moot since I just force a logout?
  - Makefile
    - Add `dev-convert-repo-to-ssh-for-push`
  - keyboard_maestro_enable_macro_syncing.sh is experimental (untested, as of 1/4/2026)
- GenoMac-system
  - clone_genomac_user_repo.sh needs to be rewritten for submodules
- Integration with Mac environment
  - To replace Antnotes, which can’t be programmatically configured, I now have a Keyboard Maestro macro (“Show Spaces assignments”) that, when trigged from the KM status menu, pops up and displays a `space_descriptions.pgn` that is assumed to be the typical screenshot of ~/Dropbox/Users/$USER/Prefs/Mission_Control_wallpapers. 
 
## Known issues
- The test for existence of Homebrew assumes an Apple Silicon Mac rather than an Intel Mac.
  - See `crash_if_homebrew_not_installed` in GenoMac-shared/scripts/helpers-apps.sh and, in particular, its
    reliance on the location `/opt/homebrew/bin/brew`.
- Generally
  - Some settings *appear* *initially* not to take, but do in fact take effect after a few logout/login cycles. Examples of these include:
    - Finder: Calculate all sizes
    - Finder: the slimmed-down toolbar
    - Preview: the slimmed-down toolbar
  - The moral is: be patient and don’t jump the gun on concluding there has been a failure.
- Desktop & Dock
  - “Highlight the element of a grid-view Dock stack over which the cursor hovers” not working as of 7/2/2025
  - Turning off autohide seems not to reliably (a) stick (i.e., the toggle in the GUI doesn’t match the value of `autohide` or the value of `autohide` doesn’t stick at zero) and (b) work (even when `autohide` is zero, the Dock still appears automatically when the cursor reaches the bottom of the screen). (Unless I don’t understand what the effect is supposed to be.)
    - This may be a known issue of early versions of macOS 26 Tahoe. See, e.g., “[Dock auto-hide will still turn itself on after a couple of screen saver / sleep / wake cycles, sometimes even after the first sleep.](https://forums.macrumors.com/threads/macos-tahoe-26-0-bug-fixes-changes-and-more.2465820/page-5#:~:text=The%20official%20release,the%20first%20sleep)”
- Matrix screensaver and hot-corner activation of screen saver
  - Under macOS Tahoe 26 Release Candidate, Matrix screen saver is not working at all, whether triggered by hot-corner activation or by the passage of time.
    - To be clear, the screen *does* darken upon either of these triggers, but the Matrix screen saver display is not shown.
    - The Matrix screen saver display *does* appear in Settings » Wallpaper » Screen Saver…
    - Other, built-in screen savers *do* behave correctly.
    - I created an issue, on September 12, 2025: [Doesn't work with macOS Tahoe 26 RC (release candidate) #24](https://github.com/monroewilliams/MatrixDownload/issues/24)
- Give audible feedback when volume is changed
  - NOTE: This may have been fixed on 11/1/2025, when I changed the type of this defaults settings from `bool` to `int`.
  - Despite the automation step, which *does* change in the indication in Settings, it might not take effect. To fix: Manually toggle that switch again.
  - As I recall, this bug goes back years.
- Keyboard Maestro
  - Despite best efforts, trying to change the menubar status icon to “Classic” doesn’t take
- Waterfox
  - Extensions
    - Neither (a) the Raindrop.io extension nor (b) the “Activist - Balanced” theme successfully installs, even though I’m installing them in the same way
      that I install all the other successfully installed extensions. The implemented workaround: Interactively prompt the executing user to manually
      install each extension.
 
## Appendix: Dev issues
The preceding content of this README focuses on the “user” experience, i.e., the experience from USER_CONFIGURER’s experience, as a consumer of the repository in its contemperaneous state.

In contrast, the present appendix addresses issues about how this repo can be changed and those changes propagated and used by USER_CONFIGURER (even if USER_CONFIGURER is the entity making those changes).

### Configure the GitHub remote to use SSH for pushing from local to GitHub
This repo is public so that it can be easily cloned at the beginning of setting up a user (way before 1Password and its SSH agent get set up). But, ultimately, the configuring user will want to make changes to the repo, and this requires being able to authenticate with GitHub.

Since GitHub doesn’t authenticate in the CLI via HTTPS, the repo needs to be configured so that it can be modified locally and pushed to GitHub, which requires SSH. Although the repo could be configured to require SSH for both fetch and push, that would require authentication even to fetch, which is a needless hassle.

Thus, we instead configure separate URLs for fetch and push:
```
cd ~/.genomac-user

# Set the fetch URL to HTTPS (no auth needed for public repo)
git remote set-url origin https://github.com/jimratliff/GenoMac-user.git

# Set the push URL to SSH (uses 1Password SSH agent)
git remote set-url --push origin git@github.com:jimratliff/GenoMac-user.git
```

### Incorporating the GenoMac-shared repo as a submodule
#### To add GenoMac-shared as a submodule of GenoMac-user
```
cd ~/.genomac-user
git submodule add https://github.com/jimratliff/GenoMac-shared.git external/genomac-shared
git commit -m "Add genomac-shared submodule"
git push origin main
```
#### For the consumer
For the consumer of GenoMac-user (and indirectly of GenoMac-shared), updating the local clone of GenoMac-user is done via:
```
cd ~/.genomac-user
git pull --recurse-submodules origin main
```
which can also be performed by `make refresh-repo`.
#### For the developer of GenoMac-user and GenoMac-shared
When a change is made to GenoMac-shared, and therefore when there is a new commit to GenoMac-shared, that new commit will not automatically be reflected in the submodule of GenoMac-user.

To ensure that the latest commit of GenoMac-shared is reflected in the submodule of GenoMac-user, the following process is performed:
```
cd ~/.genomac-user
# Updates parent repo and checks out the *pinned* submodule commits
git pull --recurse-submodules origin main
# Fetches the submodule's *latest* commit from its remote (not just what's pinned)
git submodule update --remote
# Stages the new submodule commit reference
git add external/genomac-shared
# Commits only if there's actually a change
git diff --cached --quiet external/genomac-shared || git commit -m "Update genomac-shared submodule"
# Pushes the updated submodule reference
git push origin main
```
which can also be performed by `make dev-update-repo-and-submodule`.

## Appendix: Compilation of selected settings choices (NOT exhaustive!)
The following is just a few highlights of changed settings, that might seem notable or worth knowing about:
- Linux-y stuff
  - `XDG_CONFIG_HOME`: `~/.config`
    - Many other Linux-y programs will respect that value and place their own configuration files in `~/.config`.
  - several environment variables that determine where Zsh-related dotfiles live
    - Zsh configuration files (`ZDOTDIR`): `~/.config/zsh`
    - Zsh history (`HISTFILE`): `~/.local/.state/history`
    - Zsh sessions (`XDG_ZSH_SESSIONS_DIR`): `~/.local/.state/sessions`

- Global
  - Keyboard
    - Enable keyboard navigation with Tab key
    - Use F1, F2, … as standard function keys
    - Press and release globe (🌎) key to bring up emoji picker
    - Many customizations to symbolic hotkeys, both additions and removals
      - Remove:
        - minimize a window
          - I never minimize on purpose, only accidentally; this prevents that
        - move left/right/down/up a Space
          - I use a numeric mental mode, not a spatial mental model, for Spaces
        - window-moving commands halves, quarters, arrange, since they require “Displays have separate Spaces”
      - Add
        - using ⌃⌥⌘ combination (modifiers for Mission Control)
          - ⌃⌥⌘ + 1, …, 9, 0, F1, …, F6 for navigating to Spaces 1, …, 16
          - ⌃⌥⌘F8: Activate Mission Control
          - ⌃⌥⌘F9: Notification Center
          - ⌃⌥⌘F10: Expose: application windows
          - ⌃⌥⌘F11: Show Desktop
        - using ⇧⌥⌘ (modifiers for keyboard navigation)
          - ⇧⌥⌘F2: Move focus to menu bar
          - ⇧⌥⌘F3: Move focus to the Dock
          - ⇧⌥⌘F4: Move focus to active or next window
          - ⇧⌥⌘F5: Move focus to window toolbar
          - ⇧⌥⌘F6: Move focus to floating window
          - ⇧⌥⌘F1: Turn keyboard access on or off
          - ⇧⌥⌘F7: Change the way Tab moves focus
    - Trackpad, many settings including, inter alia:
      - Tap to click
      - Swipe between pages
      - Mission Control: Swipe up with four fingers
      - Show Desktop
      - Three-finger drag
      - Remove
        - Swipe between full-screen applications
        - Notification Center
        - App Exposé (I’m not sure why I removed this)
        - Launchpad
  - Scroll bars always visible
  - Remove irritating Sequoia behavior where click-on-desktop reveals Desktop
  - Restore “Save As…” menu item as first-class visible without requiring ⌥ key
  - Cursor: Increase size and change its fill and outline colors
  - Don’t show widgets on the desktop
  - Save to disk, not to iCloud (by default)
  - Always show window proxy icon
  - Reduce transparency and increase contrast
  - All autocorrection (correcting spelling automatically, automatic capitalization, adding period with double-space, and smart quotes/dashes) is turned *off*.
    - Inline predictive text is *not* turned off, but this could be chosen by uncommenting one line.
  - Alert sound: custom: “Uh oh”
  - Language & Region: Week starts on Monday
  - Mission Control/Spaces
    - Don’t rearrange based on most-recent use
    - Each Space spans all displays (no separate Space for each monitor)
    - Don’t jump to a new space when switching applications
  - Screencaptures
    - Save to $HOME/Screenshots
    - Disable drop shadow on screenshots
- Finder
  - Open new windows to $HOME, not Recents
    - This is meant to be bootstrapped (TODO), not maintenance, so as not to prevent a user from making a different permanent choice.
  - Show (a) the Library folder, (b) hidden files, and (c) filename extensions
  - Preferred window view: List view
    - Calculate all sizes in list views
  - Column view: Resize columns to fit filenames (This is a new setting in macOS 26 Tahoe.)
  - Icon views: Snap to Grid
  - Search from current folder by default (not from “This Mac”)
- Dock
  - Turn OFF automatic hide/show of Dock
  - Enable two-finger scrolling on Dock icon to reveal thumbnails of all windows for that app.
  - Minimize to Dock rather than to app’s dock icon
    - I choose this because I never minimize on purpose, only by accident
  - Highlight the element of a grid-viewe Dock stack over which the cursor hoves
    - Needs re-testing: this wasn’t working as of 7/2/2025
  - Hot corners
    - Bottom-right: Start screen saver
    - Bottom-left: Disable screen saver
- Text Edit: Make plain text the default format
- Time Machine: Don’t prompt to use new disk as backup volume
- Disk Utility
  - Show all devices in sidebar
  - Show hidden partitions (untested as of 1/5/2026)
- Safari
  - Don’t auto-open “safe” downloads
  - Never automatically open a website in a tab rather than a window
  - Don’t navigate tabs with ⌘1 – ⌘9
  - Show full website address in Smart Search field
- Third-party software
  - BBEdit
    - is the default app to open plain-text, markdown, .plist, shell, AppleScript, and XML files
    - Soft-wrap text to window width
    - Show tab stops (as vertical lines) in editing window
    - Don’t prefer shared window for New and Open
  - ChatGPT and Claude
    - Remove hotkey
    - Do not enable menubar item

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

## Appendix: What to do when you change the BetterTouchTool preset
Status: TO DO

As of October 2025, BetterTouchTool (BTT) has no reliable method for syncing its “preset” configuration across users/Macs (although the promised delivery of this feature is overdue).

Instead, an established preset file is deployed by GenoMac-user to a location where BTT will detect it on BTT’s launching and import it for use.[^BTT-autoload-location]

[^BTT-autoload-location]: By default, BTT expects the preset-to-be-autoloaded to exist at `~/.btt_autoload_preset.json`. However, I override this location to be `~/.config/BetterTouchTool/Default_preset.json` using the syntax `defaults write com.hegenberg.BetterTouchTool BTTAutoLoadPath "~/somepath"`.

This deployment is accomplished by GenoMac-user’s dotfile-stowing process. Hence, no separate operation need be performed here to implement this (given that the dotfile-stowing process is already part of the standard GenoMac-user workflow).

It is expected that BTT’s standard preset will be very stable in the sense of rarely changing.

If the BTT preset *does* change, here are the steps to deploy the updated preset:
- Export the updated preset
  - In BetterTouchTool
    - Open BTT’s Configuration window
    - In the upper-right corner of that window, click on “Preset: Default”
    - A dialog box opens
      - Its title is “Select Master Preset”
      - It also says “Activate additional triggers from other presets (optional):”, with a list of all presets underneath. (There may be only one, named “Default”)
    - In the list of presets in that dialog box, click on “Default” (under “Preset Name”) in order to highlight that preset
    - At the bottom of the dialog box, click on “Export Highlighted” button
      - An “Exporting Preset Default” dialog box will open.
        - It says “Do you want to include all the options you changed in the BetterTouchTool settings? Or do you only want to include the various triggers you have configured (Gestures, Keyboard Shortcuts, Touch Bar Buttons etc.)?
        - It offers two buttons:
          - “Only Triggers”
          - “Triggers & Settings”
      - Click on either “Only Triggers” or “Triggers & Settings”
        - Although I don’t remember with confidence, I likely chose “Triggers & Settings”
      - A Save dialog opens
        - The file name defaults to `Default.bttpreset`
      - Choose a destination and click Save.
  - In Finder
    - Navigate to where you saved the exported BTT preset
    - Rename the file to `Default_preset.json`
      - Changing the extension to `.json` is mandatory
      - The basename/stem (viz., `Default_preset`) must conform to the environment variable `GENOMAC_USER_BTT_AUTOLOAD_PRESET_FILENAME` assigned in the script `assign_environment_variables.sh`.
- Upload the updated preset to the appropriate subdirectory of the GenoMac-user “stow directory”
  - In the GitHub web interface (or any other way that works)
    - Upload the renamed and updated preset file to: `GenoMac-user/stow_directory/BetterTouchTool/.config/BetterTouchTool`
      -  This subdirectory must conform to the environment variable `GENOMAC_USER_BTT_AUTOLOAD_PRESET_DIRECTORY` assigned in the script `assign_environment_variables.sh`.
- For every user, on every Mac, re-stow the dotfiles
  - See “[Re-“stow” the dotfiles](#re-stow-the-dotfiles)”


