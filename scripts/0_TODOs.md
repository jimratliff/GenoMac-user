# To Dos for scripts directory
This list is being generated January 28, 2026 during a major refactoring of GenoMac-user
(to conform to the advancements during the recent Hypervisor-transformation of GenoMac-system).

- ✅ scripts/tests
  - ✅ Create scripts/tests directory
  - ✅ rename path of each test script
  - ✅ All of the `make` recipes that target these scripts must be updated to reflect the current directory
    scripts/tests (instead of the prior scripts/).
- ❑ Renamimg 0_initialize_me.sh to 0_initialize_me_first.sh
  - ✅ Rename the function itself
  - ❑ Make more robust how it determines its own directory (i.e., don’t use `"${0:A}"`)
    - IN PROCESS
- Hypervisor
  - ✅ Make scripts/hypervisor directory
  - ✅ scripts/hypervisor/hypervisor.sh
  - ❑ subdermis
  - ❑ Re-write scripts/run_hypervisor.sh entry point for Make recipe
  - ❑ Move assign_enum_env_vars_for_states.sh to scripts/hypervisor
- environment variables
  - ❑ GMU_SCRIPTS_DIR    → GENOMAC_USER_SCRIPTS
  - ✅ Create GMU_HYPERVISOR_SCRIPTS
  - ❑ GMU_PREFS_SCRIPTS → GENOMAC_USER_SCRIPTS
  - ❑ New?: GMU_DOCS_TO_DISPLAY
  - ❑ New?: GMU_RESOURCES
  - ❑ New?: GMU_SCRIPTS
- ❑ pref_scripts → settings
  - ✅ rename the path of each script
  - ❑ update the environment variable that points to this directory
  - ❑ update the `source` statements that load them
- Other stuff
  - set_power_management_settings.sh
    - Is this really at the user level instead of system level?
  - ❑ Add an interactive request to set the screensaver to Matrix
