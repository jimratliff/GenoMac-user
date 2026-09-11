# About the directory `files_to_be_copied_elsewhere`

> [!NOTE]
> This is the one file in this directory that is *not* intended to be copied elsewhere!

This directory holds files that are meant to be copied elsewhere by either (a) a script or (b) a human acting manually.

## Guide to the files in this directory
- `/0_README_aliases_for_Dock.md`
  - This is a README meant to be copied by the function `create_directory_for_aliases_for_Dock` (in `scripts/installations/make_directory_for_Dock_aliases.sh`) from this location to `$DIRECTORY_OF_ALIASES_FOR_DOCK` (e.g., `$HOME/Documents/Aliases_for_Dock`).
- `finder_sidebar_favorites_name_path_pairs.jsonl`
  - This is a *template* for a particular user to (a) adapt/modify to their particular needs and (b) manually copy to `${USER_SPECIFIC_META_DIRECTORY}` (HINT: `USER_SPECIFIC_META_DIRECTORY=${LOCAL_DROPBOX_DIRECTORY}/Users/${USER}/Meta`).[^ALSO_IN_GENERIC_FINDER_SIDEBAR]
- `objects_to_alias_to_the_Dock.jsonl`
  - This is a *template* for a particular user to (a) adapt/modify to their particular needs and (b) manually copy to `${USER_SPECIFIC_META_DIRECTORY}` (HINT: `USER_SPECIFIC_META_DIRECTORY=${LOCAL_DROPBOX_DIRECTORY}/Users/${USER}/Meta`).[^ALSO_IN_GENERIC_DOCK_ALIASES]
 

[^ALSO_IN_GENERIC_FINDER_SIDEBAR]: Alternatively, this file is also in all users’ Dropbox at `~/…/Dropbox/Users/0_generic_skeleton/Prefs/Meta`. So the presence of this file here in the repo at `resources/files_to_be_copied_elsewhere` can also be seen as a version-controlled version for copying to `~/…/Dropbox/Users/0_generic_skeleton/Prefs/Meta`.

[^ALSO_IN_GENERIC_DOCK_ALIASES]: Alternatively, this file is also in all users’ Dropbox at `~/…/Dropbox/Users/0_generic_skeleton/Prefs/Meta`. So the presence of this file here in the repo at `resources/files_to_be_copied_elsewhere` can also be seen as a version-controlled version for copying to `~/…/Dropbox/Users/0_generic_skeleton/Prefs/Meta`.
