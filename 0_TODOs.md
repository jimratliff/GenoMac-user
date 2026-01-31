# To Dos
This list is being generated beginning January 28, 2026 during a major refactoring of GenoMac-user
(to conform to the advancements during the recent Hypervisor-transformation of GenoMac-system).

############### GenoMac-system
- ✅ function interactive-get_loginwindow_message() has TWO DIFFERENT VERSIONS!
  - ✅ See Claude’s analysis of the differences between the two
  - ✅ DEPRECATED version in standalone file
- ✅ Why does GenoMac-system scripts/settings have a file from GenoMac-user!?!?!?!? 🤪
  - ✅ interactive_ask_initial_questions.sh
    - ✅ DELETED
- ❑ Integrate `just` as a a partial replacement for `make`, except that `make` is required until after
  `just` is installed by Homebrew.
  - However, read “§ [Shell Completion Scripts](https://github.com/casey/just#shell-completion-scripts)” from just’s README

############### GenoMac-user
- ✅ Renamimg 0_initialize_me.sh to 0_initialize_me_first.sh
  - ✅ Rename the function itself
  - ✅ Make more robust how it determines its own directory (i.e., don’t use `"${0:A}"`)
  - ✅ Replace 0_initialize_me.sh → 0_initialize_me_first.sh in all scripts that retain a preamble
- ✅ Each script file (other than hypervisor and some utility scripts)
  - ✅ Remove entire preamble, e.g.,: source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"
- ❑ Hypervisor
  - ✅ Make scripts/hypervisor directory
  - ✅ scripts/hypervisor/hypervisor.sh
  - ✅ subdermis
    - ✅ Compact the conditional operations into single calls to `conditionally_` functions
      - ✅ Start at scripts/settings/interactive_ask_initial_questions.sh ###############WIP
  - ✅ Re-write scripts/run_hypervisor.sh entry point for Make recipe
  - ✅ Move assign_enum_env_vars_for_states.sh to scripts/hypervisor
- ❑ Configure split remote URLs for each repo
  - ❑ GenoMac-shared has helpers-git.sh, including configure_split_remote_URLs_for_GenoMac_user() and configure_split_remote_URLs_for_GenoMac_system(), but I can't find that I'm actually using them.
- ❑ Features to add
  - ❑ Interactive prompt for the user to select Matrix as their screensaver
- environment variables
  - ❑ HOMEBREW_PREFIX calculation needs to be moved to GenoMac-shared/scripts/assign_common_rnvironment_variables.sh
    - This is safe because Homebrew *must* be installed *before* either GenoMac-system or GenoMac-user runs.
  - ✅ Why isn't GMU_SCRIPTS_DIR used anywhere? Is there something else, by a different name, doing the same thing?
    - ✅ Refactored into oblivion
  - ✅ GENOMAC_USER_LOCAL_RESOURCE_DIRECTORY →   GMU_RESOURCES (These BOTH seem to exist!)
  - ✅ Create GMU_HYPERVISOR_SCRIPTS
  - ✅ GMU_PREFS_SCRIPTS → GMU_SETTINGS_SCRIPTS
  - ✅ GENOMAC_USER_DOCS_TO_DISPLAY_DIRECTORY → GMU_DOCS_TO_DISPLAY
  - ✅ New?: GMU_SCRIPTS
    - Yes, Exported but not used outside its defining script. But worth exporting anyway
  - ✅ Refactor name of GENOMAC_USER_LOCAL_STOW_DIRECTORY for consistency with similar names
    - ✅ GENOMAC_USER_LOCAL_STOW_DIRECTORY → GMU_STOW_DIR
  - ✅ Refactor name of GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS for consistency with similar names
    - ✅ GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS → GMU_LOCAL_DEFAULTS_DETECTIVE_RESULTS
- ✅ pref_scripts → settings
  - ✅ rename the path of each script
  - ✅ update the environment variable that points to this directory (GMU_SETTINGS_SCRIPTS)
  - ✅ update the `source` statements that load them
- Other stuff
  - ❑ verify_ssh_agent_configuration may be in two places?
    - It’s in scripts/settings/interactive_configure_1password.sh at the least
  - ❑ Integrate `just` as a replacement for `make`
    - However, read “§ [Shell Completion Scripts](https://github.com/casey/just#shell-completion-scripts)” from just’s README
  - ✅ defaults-detective
    - Currently partly misfiled (This should be rationalized)
      - the entry point (defaults_detective.sh) is OK: scripts/utilities
      - but there’s a separate scripts/default_detective directory
  - ❑ set_power_management_settings.sh
    - ❑ Marked as WIP
    - ❑ The test for laptop should be pulled out into GenoMac-shared as a helper (if it's not already)
    - ❑ Is this really at the user level instead of system level?
  - ❑ Add an interactive request to set the screensaver to Matrix
- ✅ shebang: Use portable version: #!/usr/bin/env zsh
  - ✅ GenoMac-user: Use only #!/usr/bin/env zsh
  - ✅ GeoMac-system: Use only #!/usr/bin/env zsh
- ✅ scripts/tests
  - ✅ Create scripts/tests directory
  - ✅ rename path of each test script
  - ✅ All of the `make` recipes that target these scripts must be updated to reflect the current directory
    scripts/tests (instead of the prior scripts/).
