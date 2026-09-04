# Assumed structure of Dropbox directory

Some components of GenoMac-user assume that user has a Dropbox directory that satisfies certain requirements.

In at least many cases, Dropbox is used to store items that (a) are not secret in the sense of a password but (b) are too sensitive to be stored in a public repository.

The below tree diagram indicates only those elements that must exist. The tree is not meant to exclude the existence of other elements.[^OMNIOUTLINER_IN_DROPBOX_NOT_USED]

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
        - SpaceJump_license_key.txt
    - Witch
      - LICENSE
        - Files_to_transfer
          - *This directory must contain the one or more Many Tricks license files*[^WHERE_WITCH_LICENSE_FILES_ARE_FOUND]
          - Jim Ratliff 1.witchlicense
          - Jim Ratliff.witchlicense
          - Jim Ratliff.witchupgradelicense


[^ALFRED_PREFS]: During the interactive configuration of Alfred, in the later portion devoted to configuring syncing of preferences, the Hypervisor reveals the `…Dropbox/Preferences_common/Alfred_preferences` directory. You will then drag the `Alfred_5_preferences` folder icon into the Open File dialog box in the Alfred preferences window.

[^BTT_LICENSE_COPIED_AUTOMAGICALLY]: The BetterTouchTool license file is copied from its Dropbox location to `$HOME/Library/Application Support/BetterTouchTool` by the function `install_btt_license_file`.

[^KM_PREF_SYNCING_ENABLED_AUTOMATICALLY]: The syncing of this Keyboard Maestro macro file is enabled automatically by the function `enable_keyboard_maestro_macro_syncing`.

[^SIDEBAR_DIVIDERS_NOT_USED_BY_GENOMAC_USER]: Although these Finder sidebar divider files are listed here, nothing about GenoMac-user actually requires that they exist. Their presence is more of a useful convention. The directory Sidebar_dividers contains multiple instances or nearly identical files whose filenames are intended to serve as occupants of the Finder sidebar that serve merely as separators between groups of other sidebar occupants. Each file’s name is of the form: ten hyphens followed by one or two digit number. The number is unique within the set, allowing all instances to coexist within a single directory. The unique number also allow them to be distinguishable, so it is clear what the next divider should be when an additional new one is needed.

[^WHERE_WITCH_LICENSE_FILES_ARE_FOUND]: You can find your Many Tricks license files at: «~/Library/Application Support/Many Tricks/Licenses». See also “[FAQ: How do I copy my licenses to another computer?](https://manytricks.com/osticket/kb/faq.php?id=2)”
