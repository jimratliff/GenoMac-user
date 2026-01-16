# How to configure Dropbox

## Launch Dropbox
- Make Dropbox the active app. (The Hypervisor should have launched Dropbox for you already.)
- Dialog box: Welcome to Dropbox!
  - Press button: Sign in with Dropbox
    - “Leave this screen open. A sign-in prompt will appear.”
- This launches your default browser
  - The URL of the new browser window is www.dropbox.com/oath2/…
  - “Log in or sign up to Dropbox to link with Dropbox”
  - This could require (a) an email address, (b) a password, and (c) a 2FA using an authenticator device
  - In a popup dialog box, agree to “Allow this site to open the dropbox-client link with Dropbox?”
      - Also ✅ for “Always allow https://www.dropbox.com to open dropbox-client links”
      - Click on “Open Link”
## Configure Selective Sync
- This launches the Dropbox app
  - Dialog box: “Welcome to Dropbox”
    - “Dropbox can’t sync over 500,000 files to this computer”
      - (Question: Was this shown to me only because I have enough files that they can’t all be synced and therefore I *must* use Selective Sync?”
      - “Very impressive! But because of this, choose specific folders you want to sync to this computer. The rest of your files are available on dropbox.com.”
    - Click on “Choose folders”
  - New window: “Selective Sync”
    - “Choose which folders you see on this device”
      - “Only selected folders will take up hard drive space on this device. You can still access unselected folders anytime at dropbox.com”
      - Choose only the “Preferences_common” folder
        - First, deselect all
        - Then, select “Preferences_common”
        - Then, click “Save”
        - Then a new dialog: “Confirm selection”
          - Only selected folders will live on this computer. Unselected folders can be accessed on dropbox.com
          - Click “Confirm”
## Remainder of onboarding
### Open Dropbox
- New window: “Welcome back!
  - “Use the right-click menu to share, send for signature, view version history, and more.”
  - Click “Next”
- New window: “We’re happy you’re back”
  - “Setup is finished.”
  - Click “Open Dropbox”
### Allow syncing
- Several new windows pop up:
  - Frontmost: “Dropbox.app” would like to start syncing.”
    - ❑ Click “OK” (other choice is “Don’t allow”)
      - (This makes all the other Dropbox dialog box—but not the Finder window—disappear)
    - “Set Up Drobox”
      - “Allow Dropbox to sync”
        - “That way, when you add or edit files, those changes will sync across everywhere you access Dropbox.”
        - Button: “Allow”
          - But this button seems moot, because the other dialog box dismisses this dialog box.
    - A Finder window pointing to the local Dropbox directory (with no obvious path information)
- New window: “More reasons to love Dropbox”
  - “Your Dropbox now lives in a secure location”
  - “Dropbox can be accessed from the shortcut under Locations in Finder.”
  - “Take our tour to check out flexible options for file storage on this Mac.”
### Make Preferences_common available offline
-The Finder window pointing to the Dropbox folder shows all of its contents as online-only.
- The Preferences_common directory should be available-offline
  - ❑ Right-click on the Preferences_common directory and choose “Make available offline”

## Return to terminal and acknowledge
- [ ] Type `done` to acknowledge that you’ve completed these manual steps.

