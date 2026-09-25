# How to configure Downie

There are two main tasks to configure Downie:
- Set the destination directory for Downie to place the videos it downloads.
- Activate your license for Downie.

## Why do I have to do this myself?
Configuring Downie requires some actions that cannot be performed through scripting.[^WHAT_CAN'T_BE_SCRIPTED]

[^WHAT_CAN'T_BE_SCRIPTED]: Neither of the following can be scripted: (a) activating the license and (b) setting the destination directory for downloads (for two reasons: (1) although setting `XUDownloadFolderURLPath` can be scripted, setting `XUDownloadFolderURL` cannot be scripted and (2) Downie needs to ask the user for permission to access the destination folder and this, too, cannot be scripted).

## Make Downie active and, if necessary, open its Settings
- ❑ Make Downie active. (GenoMac-user will have already launched Downie).
- Downie will likely present you with an onboarding wizard (because this will likely be the first time this user (on this startup volume) will have launched Downie.
  - ❑ If the onboarding wizard isn’t automatically opened for you, manually open Downie’s Settings… (⌘,)

## Set the destination directory

> [!NOTE]
> The Hypervisor has opened the following folder in the Finder: `~/Documents`.
> You may need to look behind some other windows for it.
> This folder itself contains a subfolder: `Downie_downloads`, which you can drag into an Open File Dialog in order to select `~/Documents/Downie_downloads` as the destination for Downie downloads.


### If you see the onboarding wizard (that says “Welcome to Downie!”)
- If you see the onboarding wizard, you’ll see a window with “Welcome to Downie!”
- The first screen of the onboarding-wizard window is a copyright-infringement disclaimer.
  - ❑ Click “Agree”
- The second screen is “Basic Preferences”.
  - The first line of this second screen is “Downloads Destination” with a pull-down menu (that probably defaults to “🔽 Downloads”)
  - Choose from the pull-down menu: “Choose folder…”
  - ❑ Choose the following path: `~/Documents/Downie_downloads`
    - The Hypervisor will have already created this directory.
    - The Hypervisor will already have opened the parent of this directory (viz., `~/Documents`) so that you can simply drag the subfolder `Downie_downloads` into the Open File Dialog box in order to select the desired path.
  - ❑ Approve the request for Downie to access this folder.
- Click the “Next” button.
  - You’ll see a new screen for “Browser Extensions”
  - Install—at your option—one or more of these.
- Click the “Next” button.
  - You’ll see a new screen for “What’s new in Downie 4”
- Click the “Next” button.
  - You’ll see a new screen for “How to download a video?,” etc.
- Click the “Done” button.
 
### If you do NOT see the onboarding wizard (that says “Welcome to Downie!”)
- If you don’t see the onboarding wizard, you’ll have to manually open Downie’s settings, via `⌘,`.
- If you manually open Downie’s Settings (⌘,), you’ll see a Downie Settings window.
- ❑ Select “Destination” in the left-hand sidebar of the Downie Settings window.
  - This will transform the right-hand side of the window.
- The top entry will be “Save Files to Folder”, with a pull-down menu (that probably defaults to “🔽 Downloads”)
- Choose from the pull-down menu: “Choose folder…”
  - ❑ Choose the following path: `~/Documents/Downie_downloads`
    - The Hypervisor will have already created this directory.
    - The Hypervisor will already have opened the parent of this directory (viz., `~/Documents`) so that you can simply drag the subfolder `Downie_downloads` into the Open File Dialog box in order to select the desired path.
- ❑ Approve the request for Downie to access this folder.

# Activate the license
You can activate your Downie license (which requires an email address and a license code) by using an already-synced custom macro!

- You will probably see another window “Thank you for trying out Downie 4!”
- If this is shown, it means that your Downie 4 license has not been activated.
  - The Downie 4 license must be activated for each user who uses Downie.
  - Even if you don’t see this “Thank you for trying out Downie 4!” window, your Downie license may still not be activated. (This can happen if you dismiss the “Thank you for trying out Downie 4!” window by pressing the “Continue Trial” button.
- Make Downie the active app (if it’s not already)
- Now we use a Keyboard Maestro macro to enter the name and license code necessary to activate the license.
- ❑ Click on the Keyboard Maestro menubar status icon, and choose “GenoMac Bootstrap » **Register Downie 4**”
  - This will choose the menu item: “Downie 4” » “Enter License Code…”, and then populate the
    email-address and license-code fields with the credentials under which Downie is registered.
    - Note that these credentials do *not* exist in this repo, but rather are stored in my securely privately synced macro set.
- ❑ Click on the “Activate License Code” button to confirm the assignments and complete the registration process.
  - Note that this Keyboard Maestro macro will be visible under the Keyboard Maestro menubar status icon *only* when either (a) Downie, (b) Keyboard Maestro, or (c) Alfred Preferences is the active app.

## Return to the terminal
Now return to the terminal and acknowledge you have completed the basic configuration of 1Password.

## Be tidy: Close this document
- ❑ Close this document
