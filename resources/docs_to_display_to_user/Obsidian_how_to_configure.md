# How to configure Obsidian

## Table of contents
- [Context](#context)
- [Launch Obsidian](#launch-obsidian)
- [Log in to your Obsidian account](#log-in-to-your-obsidian-account)
- [Specify the remote vault you want to sync locally and its desired local location](#specify-the-remote-vault-you-want-to-sync-locally-and-its-desired-local-location)
- [Unlock your remote vault](#unlock-your-remote-vault)
- [Adjust Obsidian settings](#adjust-obsidian-settings)
  - [Enable community plugins](#enable-community-plugins)
  - [Adjust Obsidian Sync settings](#adjust-obsidian-sync-settings)
  - [Refresh the installed community plugins](#refresh-the-installed-community-plugins)
  - [Restart Obsidian](#restart-obsidian)
- [Return to terminal and acknowledge](#return-to-terminal-and-acknowledge)
  
## Context
- Assumes your vault is already synced with Obsidian Sync, and that remote vault will be the source for your local, synced copy.
- The remote vault contains within it all of the settings for Obsidian. Thus, syncing this vault locally will make available to the current user all of your customizations to Obsidian.

## Launch Obsidian
- ❑ Make Obsidian the active app. (The Hypervisor should have launched Obsidian for you already.)

## Log in to your Obsidian account
- Assuming this is your first launch of Obsidian for this user, you’ll see four choices:
  - “Quick start”
    - **Don’t do this!**”
  - “Create new vault”
    - “Create a new Obsidian vault under a folder”
    - Button: “Create”
    - **Don’t do this!**”
  - “Open folder as vault”
    - “Choose an existing folder of Markdown files”
    - Button: “Open”
    - **Don’t do this!**”
  - “Open vault from Obsidian Sync”
    - “Set up a synced vault with existing remote vault”
    - Button: “Sign in”
- ✅ Click the “Sign in” button
  - ✅ Log in with email/password from your “Obsidian Sync” 1Password item (*not* Obsidian *Forum*)
 
## Specify the remote vault you want to sync locally and its desired local location
- You’ll see a new dialog box that presents a list of (possibly more than one) your synced vaults
  - ❑ Click the “Connect” button to the right of the vault you want to open
- You’ll see a new dialog box that says “Create synced local vault for ‘«name of vault»’”
  - Vault name
    - This is prepopulated with the original name of the vault
    - “Pick a name for your awesome vault”
    - ❑ Leave the prepopulated name alone!
  - Location
    - “Your new vault will be placed in ‘~/Documents’”
    - ❑ Use “Browse” button to select `~/Documents/Obsidian_vaults`
      - The Hypervisor has already created this folder for you
      - The Hypervisor has also already *opened* this folder for you. You can drag this folder’s folder alias icon into the Open/Save dialog box in order to set the correct location.
    - ✅ Click the “Create” button
   
## Unlock your remote vault
- If your remote vault is encrypted, you’ll see a dialog box: “The remote vault ‘my vault’ is currently encrypted. Enter your password to unlock.”
- ❑ Enter the encryption password in the “Encryption password” text field
  - (You can find this password stored in the “Obsidian Sync encryption passwords” 1Password item.)
- ✅ Click the “Unlock vault” button

## Begin syncing
- You’ll see a new dialog box: “Setup connection”
  - “You’re now connected to ‘my vault’
  - There are two buttons
    - “Manage excluded folders”
    - “Start syncing”
  - ✅ Click the “Start syncing” button

## Adjust Obsidian settings
### Enable community plugins
- Obsidian » Settings » Options » Community plugins
  - ✅ Click the “Turn on community plugins” button.
  - You’ll see, under “Current plugins,” that Obsidian thinks that “You currently have 0 plugins installed.” Don’t worry, we’ll fix that soon.
### Adjust Obsidian Sync settings
- Obsidian » Settings » Core plugins » Sync
  - **Device name**
    - ✅ Add a device name to distinguish this local clone from others
      - Use a name that combines (a) the Mac, (b) the startup volume, and (c) the user’s name.
  - **Selective sync**
    - ❑ Say ✅ to each of
      - ❑ Sync images
      - ❑ Sync audio
      - ❑ Sync videos
      - ❑ Sync PDFs
      - ✅ **Sync all other types** (only this one was OFF by default)
  - **Vault configuration sync**
    - ❑ Say ✅ to each of
      - ❑ Main settings
      - ❑ Appearance settings
      - ❑ Themes and snippets
      - ❑ Hotkeys
      - ❑ Active core plugin list
      - ❑ Core plugin settings
      - ✅ **Active community plugin list** (This was OFF by default)
      - ✅ **Installed community plugins** (This was OFF by default)
     
  NOTE: Turning on “Active community plugin list” and “Installed community plugins” will import from the remote vault (a) the list of active community plugins you want to be enabled and (b) all of the community plugins that were installed on the remote vault. However, this will *not* by itself make Obsidian aware of those community plugins. See the next step.

### Refresh the installed community plugins
By default, no community plugins are installed. Now that you’ve switched on “Active community plugin list” and “Installed community plugins,” the community plugins have been downloaded, but Obsidian is not yet aware of them.
- Obsidian » Settings » Options » Community plugins
  - Look for the **Installed plugins** section with a toggle to its right.
  - ✅ Click on the reload icon (bidirectional circular arrows)
    - This is **not** the same as “Turn on and reload” in the “Restricted mode” section above.
  - Now you will see, under “Current plugins,” “You currently have 12 (or whatever) plugins installed.”
  - You will also see under “Installed plugins,” a list of community plugins, with a toggle switch for each.
  - Note that, currently, they are all turned OFF. **Do not touch these!**

### Restart Obsidian
- ❑ ⌘Q to quit Obsidian and then relaunch the application
- This will cause the desired community plugins (according to the synced active community plugin list) to be enabled.

## Return to terminal and acknowledge
- ❑ Type `done` to acknowledge that you’ve completed these manual steps.
 
> [!NOTE]
> **Resources**
> - [Obsidian.md/account](https://obsidian.md/account/)
> - “[Set up Obsidian Sync](https://obsidian.md/help/sync/setup),” Obsidian Help.
