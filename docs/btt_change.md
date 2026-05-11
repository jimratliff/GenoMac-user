# What to do when you change the BetterTouchTool preset
(This is part of the documentation for the [GenoMac-user repository](https://github.com/jimratliff/GenoMac-user).)

**TODO WIP**

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
