# To Dos for scripts directory
This list is being generated January 28, 2026 during a major refactoring of GenoMac-user
(to conform to the advancements during the recent Hypervisor-transformation of GenoMac-system).

- scripts/tests
  - ❑ Renamimg 0_initialize_me.sh to 0_initialize_me_first.sh
    - ✅ Rename the function itself
    - ❑ Make more robust how it determines its own directory (i.e., don’t use `"${0:A}"`)
      - IN PROCESS
  - ✅ All of the `make` recipes that target these scripts must be updated to reflect the current directory
    scripts/tests (instead of the prior scripts/).
- environment variables
  - ❑ GMU_SCRIPTS_DIR    → GENOMAC_USER_SCRIPTS
- ❑ pref_scripts → settings
  - ❑ rename the path of each script
  - ❑ update the `source` statements that load them
