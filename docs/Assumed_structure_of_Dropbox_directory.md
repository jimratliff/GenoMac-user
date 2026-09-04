# Assumed structure of Dropbox directory

Some components of GenoMac-user assume that user has a Dropbox directory that satisfies certain requirements.

In at least many cases, Dropbox is used to store items that (a) are not secret in the sense of a password but (b) are too sensitive to be stored in a public repository.

At a high level, note that, for any particular user, there are two key directories:
- `Dropbox/Preferences_common`, containing files and information not specific to any user
- `Dropbox/Users/*my_user_short_name*`, containing files/information specific to that user

The below tree diagram indicates only those elements that are recognized by GenoMac-user. The tree is not meant to exclude the existence of other elements.[^OMNIOUTLINER_IN_DROPBOX_NOT_USED]

[^OMNIOUTLINER_IN_DROPBOX_NOT_USED]: Note that the actual `Dropbox/Preferences_common` directory contains (though it isn’t shown below) the immediate subdirectory `OmniOutliner_Jim's_default_document`, which contains a copy of `_JDR_OmniOutliner_Template`. This is *not* the copy that is installed by the function `set_omnioutliner_settings`. That function installs the copy at `GenoMac-user/resources/omnioutliner/_JDR_OmniOutliner_Template.oo3template`, i.e., that is found in the GenoMac-user repo itself, not in the user’s Dropbox. This OmniOutliner template isn’t deemed sensitive enough to require installing from Dropbox.

- Dropbox
  - Preferences_common
    - Alfred_preferences
      - Alfred_5_preferences[^ALFRED_PREFS]
        - Alfred.alfredpreferences
    - BetterTouchTool
      - LICENSE
        - bettertouchtool.bttlicense[^BTT_LICENSE_COPIED_AUTOMAGICALLY]
    - Keyboard_Maestro
      - Keyboard Maestro Macros.kmsync[^KM_PREF_SYNCING_ENABLED_AUTOMATICALLY
    - Sidebar_dividers[^SIDEBAR_DIVIDERS_NOT_USED_BY_GENOMAC_USER]
      - ----------1
      - ----------2
      - ----------3
      - …
    - SpaceJump
      - License_key
        - SpaceJump_license_key.txt[^SPACEJUMP_LICENSE_ACTIVATION]
    - Witch
      - LICENSE
        - Files_to_transfer
          - *This directory must contain the one or more Many Tricks license files*[^WHERE_WITCH_LICENSE_FILES_ARE_FOUND]
          - Jim Ratliff 1.witchlicense
          - Jim Ratliff.witchlicense
          - Jim Ratliff.witchupgradelicense
  - Users
    - my_user_short_name
      - Prefs
        - Meta
          - Internet_Accounts_how_to_configure_accounts.md[^INTERNET_ACCOUNTS_FILE_IS_OPTIONAL]
        - Mission_Control_wallpapers
          - 1_Project_1
          - 2_Project_2
          - …
          - 16_Project_16
      - Screenshots


[^ALFRED_PREFS]: During the interactive configuration of Alfred, in the later portion devoted to configuring syncing of preferences, the Hypervisor reveals the `…Dropbox/Preferences_common/Alfred_preferences` directory. You will then drag the `Alfred_5_preferences` folder icon into the Open File dialog box in the Alfred preferences window.

[^BTT_LICENSE_COPIED_AUTOMAGICALLY]: The BetterTouchTool license file is copied from its Dropbox location to `$HOME/Library/Application Support/BetterTouchTool` by the function `install_btt_license_file`.

[^KM_PREF_SYNCING_ENABLED_AUTOMATICALLY]: The syncing of this Keyboard Maestro macro file is enabled automatically by the function `enable_keyboard_maestro_macro_syncing`.

[^SIDEBAR_DIVIDERS_NOT_USED_BY_GENOMAC_USER]: Although these Finder sidebar divider files are listed here, nothing about GenoMac-user actually requires that they exist. Their presence is more of a useful convention. The directory Sidebar_dividers contains multiple instances or nearly identical files whose filenames are intended to serve as occupants of the Finder sidebar that serve merely as separators between groups of other sidebar occupants. Each file’s name is of the form: ten hyphens followed by one or two digit number. The number is unique within the set, allowing all instances to coexist within a single directory. The unique number also allow them to be distinguishable, so it is clear what the next divider should be when an additional new one is needed.

[^SPACEJUMP_LICENSE_ACTIVATION]: During the activation of the license for SpaceJump, the function `get_license_key_for_spacejump` reads `SpaceJump_license_key.txt` to find the license key on the first line that is neither (a) a comment (begins with '#') nor (b) blank. The function `activate_spacejump_license` then writes the license key to SpaceJump’s .plist.

[^WHERE_WITCH_LICENSE_FILES_ARE_FOUND]: You can find your Many Tricks license files at: «~/Library/Application Support/Many Tricks/Licenses». See also “[FAQ: How do I copy my licenses to another computer?](https://manytricks.com/osticket/kb/faq.php?id=2)”

[^INTERNET_ACCOUNTS_FILE_IS_OPTIONAL]: The Markdown file `Internet_Accounts_how_to_configure_accounts.md` is optional. If present (with precisely this name and location), the function `interactive_configure_internet_accounts` will display this file to the user. If absent, this function will instead a generic Markdown file not specific to any user: `GenoMac-user/resources/docs_to_display_to_user/Internet_Accounts_how_to_configure_accounts.md`
