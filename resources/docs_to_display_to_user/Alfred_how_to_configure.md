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

## Configure macOS permissions
- (Because this is the configuration of a new user, there are no existing preferences to either backup or migrate. Thus the flow switches directoy to macOS permissions.)
- The window changes to “Configure macOS Permissions: Alfred needs some simple permissions to serve you efficiently.”
  - “macOS may ask to quit or restart Alfred when granting access, select ‘Later’.”
  - “Alfred will restart at the end of the setup process.”
  - The three permissions sought
    - “Accessibility”
      - ❑ Click on “Request macOS Accessibility access” and follow instructions.
    - “Full Disk Access”
      - ❑ Click on “Open macOS Full Disk Access perferences” and follow instructions.
    - “Contacts”
      - ❌ Click on “Request macOS Contacts access” and follow instructions.
        - “Needed to search and display contacts in Alfred’s contact viewer”
        - I’m electing **not** to take this step, until/unless I have a need for it

## Return to terminal and acknowledge
- [ ] Type `done` to acknowledge that you’ve completed these manual steps.
