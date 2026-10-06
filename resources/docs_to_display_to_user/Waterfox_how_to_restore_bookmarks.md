# Waterfox: How to install your user-specific bookmarks

> [!NOTE]
> Don’t want to deal with this right this sec? Return to the terminal and enter 'punt'.
> This task will be re-presented to you next time you run the Hypervisor.

> [!WARNING]
> This step will **REPLACE ALL EXISTING BOOKMARKS!**
> If you don’t want to replace all your existing bookmarks, (1) return to the terminal and (2) type “punt” to defer this task until later without replacing any existing bookmarks.

## Look for Finder window “Bookmarks_to_import/Waterfox”

> [!NOTE]
> The Hypervisor has opened the following folder in the Finder: `~/…/Dropbox/Users/$USER/Prefs/Bookmarks/Bookmarks_to_import/Waterfox`.
> You may need to look behind some other windows in order to see it.
> This folder contains one or more `.json` files that represent bookmarks that can be restored into Waterfox.

- ❑ If there are more than one such `.json` files, identify the one you want to use as the source of the Waterfox bookmarks for this user. (For example, this may be the one with the latest timestamp in its filename.)

## Make Waterfox the active app
- ❑ Make Waterfox the active app. (The Hypervisor should have launched Waterfox for you already.)

## Open Waterfox’s Bookmarks Manager and restore the chosen `.json` file
- ❑ Open Waterfox’s Bookmarks Manager by either (a) **Bookmarks** » **Manage Bookmarks** or (b) **⇧⌘O**.
- ❑ Click on the export/import icon (**↓↑**)
- ❑ From the dropdown menu, choose **Restore** » **Choose File…**
- An Open dialog box will appear.
- ❑ From the open Finder window (Bookmarks_to_import/Waterfox) you previously identified, drag the selected `.json` file into the Open dialog box and click the “Open” button.
- This will replace your existing bookmarks with the bookmarks contained in that `.json` file.

## Return to terminal and acknowledge
- [ ] Type `done` to acknowledge that you’ve completed these manual steps.

## Be tidy: Close this document
- ❑ Close this document
