# What Hypervisor does and what settings/configurations it implements

(This is part of the documentation for the [GenoMac-user repository](https://github.com/jimratliff/GenoMac-user).)

## Table of contents
- [Programmatic steps](#programmatic-steps)
- [Dotfiles](#dotfiles)


## Programmatic steps
### This repo establishes/adjusts numerous user-level settings using a variety of techniques
This repo supplies scripts that execute various commands to establish various user settings for macOS generally and for certain apps in particular.

For many/most of the macOS settings and for many/most of the GUI apps, these scripts use macOS `defaults write` or `PlistBuddy` commands to set preferences using macOS `defaults` system.[^FIND_DEFAULTS]

[^FIND_DEFAULTS]: For tips about how to figure out what the `defaults write` commands are that correspond to a desired change in user-scoped settings, see “[Determining the `defaults write` commands that correspond to desired changes in settings](https://github.com/jimratliff/GenoMac-user/blob/main/docs/defaults_detective.md).”

Some apps, particularly non-Apple cross-platform apps such as web browsers, don’t rely entirely or at all upon macOS’s `defaults` system but instead use other mechanisms to expose their preferences to scripting. This repo nevertheless often attempts to script those apps’ preferences to the extent possible/feasible/practical. Examples of apps that use other methods for implementing preferences:
- Apps based on Electron, which store their settings in JSON configuration files.
- 1Password: 1Password is an Electron-based app and reveals its preferences in a `settings.json` file, which *should* make it straightforward to manipulate those preferences via scripting. However, presumably driven by security concerns, 1Password makes it impossible to effectively script those preferences.[^1Password_HMAC] Thus, the Hypervisor interactively walks you through configuring 1Password’s settings.
- Microsoft Word: Very few of Word’s preferences are revealed through the macOS `defaults` system. This repo implements settings for Word primarily by a combination of (a) installing a preconfigured Normal.dotm template file and (b) running a VBA script (stored within a Word document) to set some Word preferences.

[^1Password_HMAC]: 1Password’s preferences are stored at `~/Library/Group Containers/2BUA8C4S2C.com.1password/Library/Application Support/1Password/Data/settings/settings.json`. Each substantive key-value pair representing a preference is accompanied as well by a corresponding `authTags` key-value pair, with the same key but where the value is a cryptographic signature of the substantive key-value pair. The hashing is unpredictable to me (e.g.,  the hash of one key-value pair is different on one Mac than on another Mac), so I can’t write a script to provide new key-value preference pairs with `authTags` pairs that survive validation by 1Password.

### The programmatically implemented settings
(Of course, it’s possible that the below list of programmatic steps will become out of sync with the actual state of the Hypervisor’s code. So… trust, but verify! The code itself is the ultimate source of truth. The place to start reviewing to discover the settings implemented is `scripts/hypervisor/subdermis.sh`.)

Some of the following need to be performed only once, viz., the first time this user runs the Hypervisor. Thus, some of the following will be automatically skipped over on subsequent Hypervisor runs.

- Updates the local clone of this repo if the local clone is behind the remote
- Configures “split remote” for this repo: Fetch without authentication using HTTPS but push requires SSH
- Ensure that the currently running terminal emulator has Full Disk Access (FDA)
  - If not, the Settings » Privacy & Security » Full Disk Access panel is opened (this terminal app
    should already be pre-populated, but un-enabled, on the list of apps), so the user can simply
    flip the switch for this app.
  - NOTE: This is a potentially interactive step.
- The Hypervisor interactively asks for answers to some questions (only the first time the Hypervisor is run for this user):
  - Does this user want to see, on the desktop, the built-in and external drives?
  - Does this user want to configure the [Enhancer for YouTube](https://addons.mozilla.org/en-US/firefox/addon/enhancer-for-youtube/) browser extension for Waterfox?[^waterfox_default_browser]
  - Will this user sync preferences via Dropbox?
  - Will this user want to SSH authenticate GitHub using 1Password?
    - If not, will ask whether, nevertheless: Will this user want to make commits on GitHub?
  - Will this user want to configure Microsoft Word?
  - What name and email address the user wants to use for their git config[^git_config_name_email]
- Implements basic user-level settings[^basic_user_settings]
  - app-state persistence[^app_state_persistence]
  - trackpad settings[^trackpad_settings]
  - other general UI settings[^general_ui_settings]
    - Assign “Uh Oh!” as custom alert sound
    - Always show scrollbars
    - Reverse obnoxious default that revealed desktop anytime you clicked on the desktop
    - Restore to all apps the “Save As…” menu item as a first-class visible-without-option choice
    - Change size and fill and outline colors of cursor
    - Do **not** show widgets on the desktop
    - Window should display as tabs according to window’s tabbing mode
    - Double-click on window’s title bar ⇒ Zoom (reinforces default)
    - By default, save to disk, not to iCloud
    - Always show window proxy icon
    - Reduce transparency and increase contrast
    - Expand certain dialog boxes by default
  - All autocorrection (correcting spelling automatically, automatic capitalization, adding period with double-space, and smart quotes/dashes) is turned *off*.[^donot_be_arrogant]
  - keyboard-related settings
    - Holding alpha key down pops up character-accent menu (rather than repeats)[^hold_alpha_key_reinforces_default]
    - Enable Keyboard Navigation (with Tab key)
    - Use F1, F2, etc. keys as standard function keys
    - Press and release globe (🌎) key to bring up emoji picker
  - Set symbolic hot keys for Apple commands[^symbolic_hot_key_assignments]
  - Implement menubar-related settings
    - Always show Sound in menubar (not only when “active”)
    - Give audible feedback when volume is changed
    - Show battery percentage in menubar
    - Show time with seconds
    - Show Fast User Switching in menubar only as Account Name
    - Show text-input menu in menubar
  - Control Center: Add Bluetooth to Control Center to access battery percentages of Bluetooth devices
  - Dock settings[^dock_settings] (including which apps appear persistently in the Dock[^dock_persistent_apps]) and which apps should open their windows in all Spaces[^dock_open_in_all_spaces])
  - Hot corners[^hot_corners]
  -   Bottom-right corner: start screen saver
    - Bottom-left corner: Disable screen saver
  - screen-capture settings[^screen_capture_settings]
  - Mission Control/Spaces settings
    - Don’t rearrange based on most-recent use
    - Spaces span all displays (no separate space for each monitor)
    - Do not jump to a new space when switching applications
    - Do not enter Mission Control when dragging window to top of screen
  - Language & Region: Week starts on Monday
  - Notifications settings: Stops notifications from Tips app.
  - Time Machine: Don’t prompt to use new disk as backup volume
  - Set default browser to Waterfox[^set_default_browser]
  - Set default apps to open for various document types[^default_apps_for_docs]
  - interactively create additional Mission Control Spaces[^create_mission_control_spaces]
- Implements settings for Apple’s built-in apps
  - Disk Utility[^disk_utility_settings]
  - Finder[^finder_settings]<sup>,</sup>[^show_disks_on_desktop]
  - Preview.app[^preview_app_settings]
  - Safari[^Safari_settings]
  - Terminal[^terminal_app_settings]
  - Text Edit: Make plain text the default format
- Implements settings for some third-party apps
  - 1Password[^1password_setup]
  - [Alan.app](https://github.com/tylerhall/Alan)[^alan_app_settings]
  - Alfred[^alfred_settings]
  - BBEdit[^bbedit_settings]
    - Soft-wrap text to window width
    - Show tab stops (as vertical lines) in editing window
    - Don’t prefer shared window for New and Open
    - Display full path of files in “Open Recent” Items
    - When BBEdit becomes active, do nothing (don’t open a new doc)
  - BetterTouchTool[^btt_settings]
  - ChatGPT[^chatgpt_settings]
  - Claude[^claude_settings]
  - Dropbox[^dropbox_configuration]
  - Helium[^helium_settings]
  - iTerm2[^iTerm2_settings]
  - Keyboard Maestro[^keyboard_maestro_settings]
  - Matrix screensaver[^matrix_screensaver_enabling]
  - Microsoft Word[^msword_settings]
  - OmniOutliner[^omnioutliner_settings]
  - PlainTextEditor[^plain_text_editor_settings]
  - Waterfox browser and extensions[^waterfox_browser_and_extensions_settings]
  - Witch[^witch_settings]
- Set apps that should launch at login via LaunchAgents (in addition to apps that already have their own mechanisms for this)[^apps_that_launch_at_login]
 
[^waterfox_default_browser]: Waterfox, a derivative of Firefox’s Gecko browser engine, will be set as the default browser.

[^git_config_name_email]: This is asked when either (a) the user wants to SSH authenticate GitHub using 1Password or (b) otherwise wants to make commit on GitHub. Most of the git config is (a) defined at stow_directory/git/.config/git/config and (b) managed by GNU Stow. However, the \[user\] block, which contains the user’s name and email address, is not expressed in that config file (which is stored in this public repo), in order that the name/email aren’t accidentally propagated to and inadvertently adopted by other users.

[^basic_user_settings]: See `scripts/settings/perform_basic_user_level_settings.sh`.

[^app_state_persistence]: Relaunch apps and windows upon login. Closing a document confirms any pending changes.

[^trackpad_settings]: See `scripts/settings/set_trackpad_settings.sh`.

[^general_ui_settings]: See `scripts/settings/set_general_interface_settings.sh`.

[^donot_be_arrogant]: See `scripts/settings/set_auto_correction_suggestion_settings.sh`. Inline predictive text is *not* turned off, but this could be chosen by uncommenting one line.

[^hold_alpha_key_reinforces_default]: This doesn’t change the default; it affirms/reinforces it.

[^symbolic_hot_key_assignments]: See `scripts/settings/set_symbolichotkeys.sh`. Disables some default hotkeys and changes the default hotkeys for some actions.

[^dock_settings]: See `scripts/settings/set_general_dock_settings.sh`. Turn *off* automatic show/hide; turn *on* magnification when hovering; set magnification size; show indicator lights for open apps; icons of hidden apps are translucent; enable two-finger scrolling on Dock icon to reveal thumbnails of all windows; minimize to Dock rather than to app’s Dock icon. The (a) app lineup on the Dock and (b) which apps are supposed to open in all spaces is specified on a one-time bootstrap basis by `scripts/settings/perform_initial_bootstrap_operations.sh`.

[^dock_persistent_apps]: As a bootstrap step, the Dock is deleted and is replaced by a lineup (System Settings, 1Password, {{TextExpander has been DEPRECATED from Project GenoMac: TextExpander,}} Waterfox, Helium, Raindrop.io, Obsidian, Zed, Activity Monitor, and iTerm) that is defined in `scripts/settings/bootstrap_dock.sh`. This is a *bootstrap* step, but not an enforcement/maintenance step: the Dock configuration can be changed by the user and subsequent runs of Hypervisor will *not* overrule those user changes.

[^dock_open_in_all_spaces]: These apps (1Password, Activity Monitor, Calendar, Contacts, Notes, Reminders, Stickies, and System Settings {{TextExpander has been DEPRECATED from Project GenoMac: TextExpander,}}) are specified in `implement_mission_control_assign_to_options_for_selected_apps()` in `scripts/settings/set_mission_control_assign_to_options.sh`. These particular apps were chosen primarily because (a) with the exception of Stickies, they are single-window apps and (b) each could reasonably be desired to appear in multiple Spaces. Thus, if one of these apps was *not* desired in a particular Space, the app could be hidden and re-displayed when needed.

[^hot_corners]: See `scripts/settings/set_general_dock_settings.sh`

[^screen_capture_settings]: See `scripts/settings/set_screen_capture_settings.sh`. (a) Disable drop shadow. (b) Set screenshot destination to `~/Screenshots`. However: TODO: needs to be bifurcated to deal with Dropbox screenshot destinations. Setting the location should be separated from the other screen-capture preferences because this would be user-specific.

[^set_default_browser]: See `set_default_browser()` in `scripts/settings/set_default_browser.sh`. This causes five different handlers to be set. Mysteriously to me, one of these steps can take a long time. Be patient.

[^default_apps_for_docs]: These assignments are made by `set_default_apps_to_open()` in `scripts/settings/set_default_apps_to_open.sh`. For example, BBEdit is assigned to open plain-text, Markdown, .plist, shell scripts, XML, and AppleScript files. Elmedia Player is assigned to open MPEG, QuickTime, m4v, and .avi files.

[^create_mission_control_spaces]: See `scripts/settings/interactive_create_mission_control_spaces.sh`.

[^finder_settings]: See `scripts/settings/set_finder_settings.sh`. The toolbar is specified on a one-time bootstrap basis by `scripts/settings/perform_initial_bootstrap_operations.sh`.

[^show_disks_on_desktop]: If the user answered the introductory question “Does this user want to see, on the desktop, the built-in and external drives?” in the affirmative, the defaults of not showing these will be reversed by the function `conditionally_reverse_disk_display_policy_for_some_users`.

[^preview_app_settings]: See `scripts/settings/set_preview_settings.sh` and, for implementing the toolbar, `scripts/settings/bootstrap_preview_app.sh`. The toolbar is specified on a one-time bootstrap basis by `scripts/settings/perform_initial_bootstrap_operations.sh`.

[^disk_utility_settings]: See `scripts/settings/set_diskutility_settings.sh`. (a) Show all devices in sidebar; (b) show hidden partitions.

[^Safari_settings]: See `scripts/settings/set_safari_settings.sh`.

[^terminal_app_settings]: See `scripts/settings/set_terminal_settings.sh`. Sets style for new windowsand stating windows: “Man Page”.

[^1password_setup]: See `scripts/settings/interactive_configure_1password.sh`. Hypervisor interactively walks you through configuring 1Password both (a) for normal user and (b) to use the 1Password SSH agent to authenticate with GitHub in the CLI.

[^alan_app_settings]: See `scripts/settings/set_alan_app_settings.sh`.

[^alfred_settings]: See `scripts/settings/interactive_configure_alfred.sh`.

[^bbedit_settings]: See `scripts/settings/set_bbedit_settings.sh`.

[^btt_settings]: See `scripts/settings/set_bettertouchtool_settings.sh`. This script file works in conjunction with a dotfile that contains the BetterTouchTool configuration: `stow_directory/BetterTouchTool/.config/BetterTouchTool/Default_preset.json`. The script tells BetterTouchTool where to find this file (after it has been deployed by GNU Stow). Also installs the BetterTouchTool license, which is sourced from the user’s Dropbox (and thus this step is performed only after Dropbox is configured).

[^chatgpt_settings]: See `scripts/settings/set_chatgpt_settings.sh`.

[^claude_settings]: See `scripts/settings/set_claude_settings.sh`.

[^dropbox_configuration]: See `scripts/settings/interactive_configure_dropbox.sh`.

[^helium_settings]: See `scripts/settings/interactive_configure_helium.sh`.

[^iTerm2_settings]: See `scripts/settings/set_iterm_settings.sh`.

[^keyboard_maestro_settings]: See `scripts/settings/interactive_configure_keyboard_maestro.sh`.

[^matrix_screensaver_enabling]: See `scripts/settings/interactive_configure_screensaver.sh`.

[^msword_settings]: See `scripts/settings/set_microsoft_word_settings.sh`.

[^omnioutliner_settings]: See `https://github.com/jimratliff/GenoMac-user/blob/main/scripts/settings/set_omnioutliner_settings.sh`. In addition to directly implementing settings, this script installs a template OmniOutliner document provided at `resources/omnioutliner/_JDR_OmniOutliner_Template.oo3template`.

[^plain_text_editor_settings]: See `scripts/settings/set_plain_text_editor_settings.sh`.

[^waterfox_browser_and_extensions_settings]: See `scripts/settings/set_waterfox_settings.sh`.

[^witch_settings]: See `scripts/settings/set_witch_settings.sh`. (a) Installs Witch license files, which are assumed to be provided in Dropbox. (b) Sets Witch settings.

[^apps_that_launch_at_login]: See `scripts/settings/set_apps_to_launch_at_login.sh`. The apps currently specified to auto-launch on login are (a) [Alan.app](https://tyler.io/2025/11/26/alan/), (b) BetterTouchTool, and (c) Keyboard Maestro Engine. The following apps are *not* added to this list, even though it *is* desired that they auto-launch at login, because empirically these apps have their own mechanism to enforce auto-launch at login without being added to this LaunchAgents list: (a) Dropbox, (b) {{TextExpander has been DEPRECATED from Project GenoMac: TextExpander,}}, and (c) Alfred. When specifying an app to auto-open at login, the app can be referenced by either its (a) bundle ID or (b) its absolute path. The apps to auto-open are specified by adding them to the associative array `GENOMAC_LOGIN_APPS` in `scripts/settings/set_apps_to_launch_at_login.sh`.

## Dotfiles
Note, in particular, the following non-exhaustive list of particular settings scattered among the dotfiles:
- 1Password
  - `stow_directory/1password/.config/1Password/ssh/agent.toml` specifies that the keys only from the 'Dev' vault are accessible to the 1Password SSH Agent
- BetterTouchTool
  - `stow_directory/BetterTouchTool/.config/BetterTouchTool/Default_preset.json` provides customized settings for [BetterTouchTool](https://folivora.ai/) to all users and Macs.[^POINTING_BTT_TO_DOTFILE]
- Git
  - `stow_directory/git/.config/git/git_ignore_global` specifies a default, global .gitignore file
  - `stow_directory/git/.config/git/config`
    - Typically, this file is where your name and email for commits *could* be entered, but GenoMac-user does things differently.[^GIT_CONFIG_USER_IS_INCLUDED]
    - Specifies `rebase = true`, `autostash = true`, and `editor = bbedit`
- Homebrew
  - `stow_directory/homebrew/.config/homebrew/brew.env` specifies that Homebrew should install apps so that they will not be quarantined on first use (`HOMEBREW_CASK_OPTS=--no-quarantine`)
- Starship
  - `stow_directory/starship/.config/starship.toml` defines a highly opinionated, two-line shell prompt using [Starship](https://starship.rs/). It relies on a Nerd Font being installed, which is satisfied by GenoMac-system
- Zed
  - `stow_directory/zed/.config/zed/settings.json` provides the settings for the [Zed editor](https://zed.dev/)
- zsh
  - `stow_directory/zsh/.config/zsh/.zshenv` defines `XDG_CONFIG_HOME` to be `~/.config`. Many other Linux-y programs will respect that value and place their own configuration files in `~/.config`.
  - `stow_directory/zsh/.config/zsh/.zsh_aliases` defines numerous *aliases*, many of which depend on particular programmed that were installed by GenoMac-system. For example, `alias ls="eza"` and `alias cat="bat"`.
 
[^GIT_CONFIG_USER_IS_INCLUDED]: To avoid hardwiring any particular user name and email address into this repo, `stow_directory/git/.config/git/config` (a) supplies the dummy values “Default User” and “default@example.com”, respectively, and (b) ends with an `[include]` that references the overriding file `~/.config/genomac-user/git/gitconfig-personal`, which exists outside the local clone. That `gitconfig-personal` file is written by the Hypervisor, using a name and email address supplied by the user running the Hypervisor. (This assumes the user either (a) answers 'y' to “Will this user want to SSH authenticate GitHub using 1Password?” or (b) answers 'y' to “Will this user want to make commits on GitHub?,” which is asked if the answer to the 1Password question is 'n'.)

[^POINTING_BTT_TO_DOTFILE]: BetterTouchTool must be instructed, by a `defaults write` command, to refer to that dotfile to obtain its settings. See [Andreas Hegenberg’s answer](https://community.folivora.ai/t/syncing-the-config-in-git/34840) to “Syncing the config in Git.” This instruction is taken care of by the Hypervisor; see `scripts/settings/set_bettertouchtool_settings.sh`.

GNU Stow, guided by the directory structure of `stow_directory`, creates symlinks near the root of the user’s directory to make it appear like the supplied dotfiles are located when various programs expect them to be, e.g., in `~/.config`.[^STOW_DIR_METHOD]

[^STOW_DIR_METHOD]: `stow_directory` is structured such that, for each package, the structure of the directory corresponding to that package mimics where the symlinks pointing to these files will reside relative to the user’s $HOME directory. (E.g., `stow_directory/git/.config/git/conf` is the target of a symlink at `~/.config/git/conf`.) Jake Wiesler’s “[Manage Your Dotfiles Like a Superhero](https://www.jakewiesler.com/blog/managing-dotfiles),” September 20, 2021, has the best explanation of this I’ve ever seen.
