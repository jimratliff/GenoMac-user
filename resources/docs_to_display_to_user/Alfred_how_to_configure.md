# How to configure Alfred

## Launch Alfred
- Make Alfred the active app. (The Hypervisor should have launched Alfred for you already.)
- You will see a “Welcome to Alfred 5” dialog box
  - “There are just a few things we need to do before we get started”
    - “Configure your Powerpack”
      - “You will be able to optionally enter your Powerpack details for uninterrupted Alfred productivity.”
    - “Backup previous Alfred Preferences”
      - “If you are migrating from Alfred 2 or above, this step will allow you to backup your prefereces before migrating.”
    - “Migrate Preferences”
      - “This step will allow you to import your preferences, or if syncing, use your already synced preferences”
    - “Set up macOS Permissions”
      - “Alfred requires certain macOS permissions to automate your Mac. This step will get you started.”
    - There are three buttons: “Quit,” “Skip Setup,” and “Begin Setup…”

## Activate Alfred Powerpack
- The window changes to “Activate Alfred Powerpack: Enter your Alfred 5 Powerpack License, or skip to use Alfred’s core features.”
  - “If you have a Mega Supporter License, or purchased since 1st Jan 2022, select ‘Buy or Upgrade Powerpack’ to obtain your free upgrade.’”
- You can activate Alfred’s Powerpack by using an already-synced custom macro!
- When you reach this “Activate Alfred Powerpack” window, the focus is already in the text box into which to paste the License.
- ❑ Click on the Keyboard Macro menubar status icon, and choose “GenoMac Bootstrap » Paste Alfred Powerpack License”
- This will paste the License code into the text box.
  - Note that this License text does *not* exist in this repo, but rather is stored in my securely privately synced macro set.
- ❑ Click on the “Activate” button to confirm the assignments and complete the activation process.
  - ❑ You’ll see, *inter alia*, “Thank you, you’re amazing ;)”
- ❑ Click on the button: “Next Step…”

## Migrate Preferences to Alfred 5
Suprisingly, and I don’t totally understand it…
- The window changes to “Migrate Preferences to Alfred 5”
  - “An older version of Alfred’s preferences has been found”
  - Preferences: ~/Library/CloudStorage/Dropbox/Preferences_common/Alfred_preferences/ (this may simply be truncated here, because it should have the Alfred_5_preferences subfolder
  - Local Data: ~/Library/Application Support/Alfred 2
    - I have no idea where this comes from! Maybe it’s related to setting the sync folder programmatically.
- ❑ Click the button: “Skip Migration…”

## Configure macOS permissions
- (Because this is the configuration of a new user, there are no existing preferences to either backup or migrate. Thus the flow switches directoy to macOS permissions.)
- **NOTE** Some of the below permissions may already be set if you’ve previously configured another user on the same Mac to use Alfred. Some/all of these permissions appear to be at the system level.
- The window changes to “Configure macOS Permissions: Alfred needs some simple permissions to serve you efficiently.”
  - “macOS may ask to quit or restart Alfred when granting access, select ‘Later’.”
  - “Alfred will restart at the end of the setup process.”
  - The three permissions sought
    - “Accessibility”
      - “Alfred requires accessibility access on your Mac if you’d like to use snippet expansion, or to simulate key events (from workflows, file selection, clipboard integration and system commands).
      - ❑ Click on “Request macOS Accessibility access” and follow instructions.
        - Dialog box: “‘Alfred 5.app’ would like to control this computer using accessibility features.”
          - “Grant access to this application in Privacy & Security settings, located in System Settings.”
          - ❑ Click on “Open System Settings”
    - “Full Disk Access”
      - “Allowing Full Disk Access gives Alfred access to the user-level files on your Disk. This is essential if you’d like Alfred to be able to search for your browser bookmarks and other files in your home Library folder.”
      - ❑ Click on “Open macOS Full Disk Access perferences” and follow instructions.
      - **NOTE:** Although System Settings » Full Disk Access window did open, Alfred was *not* listed by default.
      - ❑ **Manually** add Alfred 5 to the list of Full Disk Access apps.
    - “Contacts”
      - ❌ Click on “Request macOS Contacts access” and follow instructions.
        - “Needed to search and display contacts in Alfred’s contact viewer”
        - I’m electing **not** to take this step, until/unless I have a need for it
        - **NOTE:** I still had to click on “Request macOS Contacts acess” (in order to get the “Next Step…” option, but I declined to turn that permission on.
       
## Configure syncing
### Context for configuring perference syncing
- **NOTE:** The Hypervisor has opened the following folder in the Finder. You may need to look behind some other windows for it.
  - ~/Library/CloudStorage/Dropbox/Preferences_common/Alfred_preferences
  - This `Alfred_preferences` folder itself contains a subfolder: `Alfred_5_preferences`, which Alfred will use to find the `Alfred.alfredpreferences` file.
### Procedure to configure preference syncing
- Make Alfred’s Preferences window active
- Click “Advanced” in the left column
- In the lower right-hand side of that window, is the “Syncing” area
- Click the “Set preferences folder…” button
- This opens an Open File dialog, which is looking for a particular **folder* (not a file)
- You will want to select a particular path:
  - ~/Library/CloudStorage/Dropbox/Preferences_common/Alfred_preferences/Alfred_5_preferences
  - The easiest way to provide this path is to find the Finder window the Hypervisor has already opened:
    - ~/Library/CloudStorage/Dropbox/Preferences_common/Alfred_preferences
    - This folder contains within it: Alfred_5_preferences
    - Drag the folder icon for Alfred_5_preferences into the Open File dialog box in the Alfred preferences window.
  - Confirmation dialog box
    - “Alfred will use the Alfred.alfredprefeences in the specified folder.”
      - “Don’t forget, Time Machine backups are your friend!”
      - “IMPORTANT: If the specified folder is a synced folder, be sure to set up syncing on your primary Mac first and allow Alfred’s settings to fully sync and propagate before setting up other Macs. These Macs will then use the synced preferences.”
    - ❑ Click on the button “Set folder and restart Alfred”

## Return to terminal and acknowledge
- [ ] Type `done` to acknowledge that you’ve completed these manual steps.
