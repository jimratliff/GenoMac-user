# How to configure Obsidian

> [!WARNING]
> This is a TODO! It’s WIP

> [!WARNING]
> Do **NOT** plunge ahead with the offered configuration Wizard!
> 
> It tells you to sync before adjusting Selective Sync settings, and that’s wrong!

> [!NOTE]
> This configuration assumes that you already have a vault that actively uses Obsidian Sync to sync.

> [!NOTE]
> **Resources**
> - [Obsidian.md/account](https://obsidian.md/account/)
> - “[Set up Obsidian Sync](https://obsidian.md/help/sync/setup),” Obsidian Help.

## Launch Obsidian
- ❑ Make Obsidian the active app. (The Hypervisor should have launched Obsidian for you already.)

## Log in to your Obsidian account
- Assuming this is your first launch of Obsidian for this user, you’ll see four choices:
  - “Create new vault”
    - “Create a new Obsidian vault under a folder”
    - Button: “Create”
  - “Open folder as vault”
    - “Choose an existing folder of Markdown files”
    - Button: “Open”
  - “Open vault from Obsidian Sync”
    - “Set up a synced vault with existing remote vault”
    - Button: “Sign in”
- ❑ Click the “Sign in” button
  - ❑ Log in with email/password from your “Obsidian Sync” 1Password item (*not* Obsidian *Forum*)
 
## Sync your remote vault to its desired local location
- You’ll see a new dialog box that presents a list of (possibly more than one) synced vaults
  - ❑ Click the “Connect” button to the right of the vault you want to open
- You’ll see a new dialog box that says “Create synced local vault for ‘«name of vault»’”
  - Vault name
    - This is prepopulated with the original name of the vault
    - “Pick a name for your awesome vault”
    - ❑ Leave the prepopulated name alone!
  - Location
    - Your new vault with be placed in “~/Documents”
    - Use “Browse” button to select `~/Documents/Obsidian_vaults`
      - The 🚨 has already created this folder for you
      - The Hypervisor has also already *opened* this folder for you. You can drag this folder’s folder alias icon into the Open/Save dialog box in order to set the correct location.
    - ❑ Click the “Create” button
   
## Unlock your remote vault but… do NOT start syncing
- If your remote vault is encrypted, you’ll see a dialog box: “The remote vault ‘my vault’ is currently encrypted. Enter your password to unlock.
- ❑ Enter the encryption password in the “Encryption password” text field
  - This password is stored in the “Obsidian Sync encryption passwords” 1Password item
- ❑ Click the “Unlock vault” button
- You’ll see a new dialog box: “Setup connection”
  - “You’re now connected to ‘my vault’
  - There are two buttons
    - “Manage excluded folders”
    - “Start syncing”
- **🚨🚧🛑 Whoa! Stop! Do not click “Start syncing” yet! 🛑🚧🚨**
- **Close (or dismiss) the “Setup connection” dialog**

## Adjust Obsidian Sync settings before actually starting the sync
- ❑ Obsidian » Settings » Sync
  - **Device name**
    - ❑ Add a device name
      - Use both the name of the Mac *and* the user’s name
  - **Selective sync**
    - ❑ Say ✅ to each of
      - ❑ Sync images
      - ❑ Sync audio
      - ❑ Sync videos
      - ❑ Sync PDFs
      - ❑ Sync all other types
    - **Vault configuration sync**
      - ❑ Say ✅ to each of
        - ❑ Main settings
        - ❑ Appearance settings
        - ❑ Themes and snippets
        - ❑ Hotkeys
        - ❑ Active core plugin list
        - ❑ Core plugin settings
        - ❑ Active community plugin list
        - ❑ Installed community plugins
- ❑ If you made any settings, restart Obsidian completely.
- ❑ Once Obsidian has restarted, return to Settings » Sync.
  - ❑ **TODO DOCUMENT: How to turn on sync?**
 
## Turn on community plugins and install desired community plugins
- ❑ Settings » Community plugins
- ❑ Click the “Turn on community plugins”

############### TODO: Need to add installing community plugins

     
## ############### TEMPORARY HOLDING PLACE FOR OLD, POSSIBLY OBSOLETE INSTRUCTIONS

## Log in to your Obsidian account
- In Obsidian, open **Settings**
  - In the left sidebar, select “Settings ⚙️” or
  - Use the Command palette, by typing ⌘P (and then what❓❓❓)
- Check for updates
- Select **General** in the sidebar
- Under **Account » Your Account**, Select **Log in**
  - Enter email address and password, select **Login**

## Enable syncing
(The vault should be synced to an immediate subfolder (with the name of the vault) of `~/Dropbox/Obsidian_vaults`.)

- In Obsidian, open **Settings**
- In the sidebar, under **Options**, select **Core Plugins**
- Toggle **Sync**

## Create a local vault from the contents of your synced remote vault
- In the section that says “Open vault from Obsidian Sync,” choose **Setup**
- Login with your Obsidian User account
- You will be asked to choose which remote vault you want to sync to this device. Select **Connect**.
- You will be asked to choose a name for the local vault that will be created on the device to hold this data. *Enter the same name as the local vault on your other device*.
- Select **Create**.
- The remove vaults window will pop up momentarily as Obsidian Sync connects to your server and validates the subscription. It will then present you a with a *Setup Connection* window.
- **It is highly recommended that you close or swipe down from this window, and [adjust Obsidian Sync settings](https://obsidian.md/help/sync/setup#Adjust%20Obsidian%20Sync%20settings) first!**

## Remainder of onboarding



## Return to terminal and acknowledge
- ❑ Type `done` to acknowledge that you’ve completed these manual steps.
