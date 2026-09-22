# How to configure Downie

## Why do I have to do this myself?
Configuring Downie requires some actions that cannot be performed through scripting.[^WHAT_CAN'T_BE_SCRIPTED]

[^WHAT_CAN'T_BE_SCRIPTED]: Neither of the following can be scripted: (a) activating the license and (b) setting the destination directory for downloads (for two reasons: (1) although setting `XUDownloadFolderURLPath` can be scripted, setting `XUDownloadFolderURL` cannot be scripted and (2) Downie needs to ask the user for permission to access the destination folder and this, too, cannot be scripted).

## Make Downie active and, if necessary, open its Settings
- ❑ Make Downie active. (GenoMac-user will have already launched Downie).
- Downie will likely present you with an onboarding wizard (because this will likely be the first time this user (on this startup volume) will have launched Downie.
  - ❑ If the onboarding wizard isn’t automatically opened for you, manually open Downie’s Settings… (⌘,)

## Set the destination directory
Regardless of whether (a) you see the onboarding wizard or (b) manually open Downie’s Settings, you can set the destination directory:
  - If you see the onboarding wizard,
  - If you manually open Downie’s Settings,
    - ❑ select “Destination” in the left-hand sidebar of the Downie Settings window.
    - This will transform the right-hand side of the window.
    - The top entry will be “Save Files to Folder”, with a pull-down menu
    - Choose from the pull-down menu: “Choose folder…”
- ❑ Choose the following path: `~/Documents/Downie_downloads`
- ❑ Approve the request for Downie to access this folder.

### General
- “Prefill username when creating a new login”
  - ❑ Change from ✅ → ❌
#### Keyboard Shortcuts
- “Show Quick Access”
  - ❑ Change to ⌃⌥⌘]   (To be clear, the last character is a closing square bracket. That *is* part of the shortcut.)
- “Lock 1Password”
  - ❑ REMOVE SHORTCUT
- “Autofill”
  - ❑ Change to ⌃⌥⌘.   (To be clear, the last character is a period. That *is* part of the shortcut.)
### Appearance
#### Always Show in Sidebar
- Categories
  - ❑ Change from ❌ → ✅
- Tags
  - ❑ Change from ✅ → ❌
### Security
#### Unlock
*NOTE: The following applies only to accounts that will use Touch ID to authenticate in macOS*
- “Unlock using Touch ID”
  - ❑ Change from ❌ → ✅
  - (This may have already been ✅-ed, if you were presented with an earlier dialog box about this option.)
- - “Unlock app with Mac password”
  - ❑ Change from ✅ → ❌
- “Require account password after”
  - ❑ Set at **30** days
#### Auto-lock
- “Lock after the device is idle for”
  - ❑ Change from 1 hour → **8 hours**
#### Concealed Fields
- “Hold Option to toggle revealed fields”
  - ❑ Change from ❌ → ✅

## Return to the terminal
Now return to the terminal and acknowledge you have completed the basic configuration of 1Password.

## Be tidy: Close this document
- ❑ Close this document
