#!/usr/bin/env zsh

# Establishes values for environment variables that act as enums corresponding
# to states.
#
# Assumes that export_and_report() has already been made available
#
# There are two kinds of steps:
# - Bootstrap
# 	- Typically executed once per user (on a given Mac)
# 		- Examples
# 			- a setting that is initialized to a default value but where it is anticipated that
# 			  the user may override that setting and would not want their override to itself
# 			  be overridden by re-running the original configuration script
# 			  - e.g., a Dock lineup, toolbar configurations of particular apps
# 			- an action that, despite being idempotent (in a sense), you wouldn’t want to repeat
# 			  because the action is time consuming or otherwise costly
# 			  - e.g., setting the default browser (I don’t know why this is so time consuming, 
# 			    but it is!)
# 			  - e.g., registering a QuickLook plugin (costly because launching and then quitting 
# 			    an app takes time)
# 			- a manual configuration that can’t be automated (and therefore is too expensive for
# 			  thoughtless repetition, even if doing so would be idempotent)
# 			  - e.g., authentication of an app or external service
# 			  - e.g., implementing a setting that isn’t exposed to scripting (e.g., granting 
# 			    full-disk access to an app)
# - Maintenance
# 	- Must be idempotent
# 	- Repeated periodically either (a) to enforce previously set settings or (b) to reflect
# 	  recent changes
# 	  - Examples:
# 	  	- stowing dotfiles
# 	  	- `defaults write` commands, where you want to continually enforce the choices 
# 	  	  specified by GenoMac-user, even if the user has deviated from those
# 	  	  
# The key of each state:
# - begins with either
#   - `GMS_` (GenoMac-system) or
#   - `GMU_` (GenoMac-user)
# - immediately followed by either:
# 	- `PERM_` for “permanent”
# 		- Such a `GMx_PERM_` key persists across sessions. It is reset (i.e., deleted) only
# 		  if an extraordinary circumstance arises that, after deliberation, is found to 
# 		  warrant the repetition of this otherwise-bootstrap step.
# 	- `SESH_` for “session”
# 		- is cleared/reset/deleted as the final step of each successful session (or possibly
# 		  at the beginning of each “new” session, though it’s not clear how to easily 
# 		  determine that—without determining that the current SESH states take you all the 
# 		  way to the end)
# 		- `SESH_` states provide a mechanism such that the hypervisor script can be re-entered
# 			(for example, following an enforced logout) and be able to determine which steps
# 			can be skipped over and where to pick up the remaining sequence.
# 		  
# The state mechanism is managed by the repository (i.e., GenoMac-system or GenoMac-user).
# Therefore the state mechanism doesn’t cover the earliest stages of the GenoMac-system
# or GenoMac-user processes that instruct/direct the user to achieve the local cloning
# of the repository.
# 
# 
# - `GMx_SESH_intro_questions_have_been_answered`
# 	- The initial set of questions from the script to the executing user have been
# 	  comprehensively asked and answer.
# - `GMU_PERM_user_is_sysadmin`
# - `GMU_SESH_dotfiles_have_been_stowed`
# 	- The dotfiles have been stowed	

set -euo pipefail

GMU_PERM_1PASSWORD_HAS_BEEN_AUTHENTICATED="gmu_perm_1password_has_been_authenticated"
GMU_PERM_1PASSWORD_HAS_BEEN_CONFIGURED="gmu_perm_1password_has_been_configured"
GMU_PERM_1PASSWORD_USER_WANTS_TO_CONFIGURE_SSH_AGENT="gmu_perm_1password_user_wants_to_configure_ssh_agent"
GMU_PERM_ALFRED_HAS_BEEN_CONFIGURED="gmu_perm_alfred_has_been_configured"
GMU_PERM_BASIC_BOOTSTRAP_OPERATIONS_HAVE_BEEN_PERFORMED="gmu_perm_basic_bootstrap_operations_have_been_performed"
GMU_PERM_DROPBOX_HAS_BEEN_CONFIGURED="gmu_perm_dropbox_has_been_configured"
GMU_PERM_DROPBOX_USER_WANTS_IT="gmu_perm_dropbox_user_wants_it"
GMU_PERM_FINDER_SHOW_DRIVES_ON_DESKTOP="gmu_perm_finder_show_drives_on_desktop"
GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED="gmu_perm_intro_questions_asked_and_answered"
GMU_PERM_KEYBOARD_MAESTRO_HAS_BEEN_CONFIGURED="gmu_perm_keyboard_maestro_has_been_configured"
GMU_PERM_MICROSOFT_WORD_HAS_BEEN_AUTHENTICATED="gmu_perm_microsoft_word_has_been_authenticated"
GMU_PERM_MICROSOFT_WORD_HAS_BEEN_CONFIGURED="gmu_perm_microsoft_word_has_been_configured"
GMU_PERM_MICROSOFT_WORD_USER_WANTS_IT="gmu_perm_microsoft_word_user_wants_it"
GMU_PERM_TEXTEXPANDER_HAS_BEEN_CONFIGURED="gmu_perm_textexpander_has_been_configured"

GMU_SESH_BASIC_IDEMPOTENT_SETTINGS_HAVE_BEEN_IMPLEMENTED="gmu_sesh_basic_idempotent_settings_have_been_implemented"
GMU_SESH_DOTFILES_HAVE_BEEN_STOWED="gmu_sesh_dotfiles_have_been_stowed"
GMU_SESH_FINDER_SHOW_DRIVES_ON_DESKTOP_HAS_BEEN_IMPLEMENTED="gmu_sesh_finder_show_drives_on_desktop_has_been_implemented"
GMU_SESH_REACHED_FINALITY="gmu_sesh_reached_finality"
GMU_SESH_SESSION_HAS_STARTED="gmu_sesh_session_has_started"


# Define environment variables corresponding to states
# GENOMAC_USER_STATE_1PASSWORD_IS_CONFIGURED_FOR_SSH_AND_GITHUB
# GENOMAC_USER_STATE_BETTER_TOUCH_TOOL_LICENSE_IS_INSTALLED
# GENOMAC_USER_STATE_DOCK_TOOLBARS_QL_PLUGINS_ARE_INITIALIZED
# GENOMAC_USER_STATE_DROPBOX_HAS_SYNCED_COMMON_PREFS
# GENOMAC_USER_STATE_DROPBOX_IS_AUTHENTICATED
# GENOMAC_USER_STATE_MICROSOFT_WORD_IS_AUTHENTICATED
# GENOMAC_USER_STATE_MICROSOFT_WORD_IS_CONFIGURED
# GENOMAC_USER_STATE_TEXT_EXPANDER_IS_AUTHENTICATED

# Export environment variables to be available in all subsequent shells
report_action_taken "Exporting environment variables corresponding to states."

export_and_report GMU_PERM_1PASSWORD_HAS_BEEN_AUTHENTICATED
export_and_report GMU_PERM_1PASSWORD_HAS_BEEN_CONFIGURED
export_and_report GMU_PERM_1PASSWORD_USER_WANTS_TO_CONFIGURE_SSH_AGENT
export_and_report GMU_PERM_ALFRED_HAS_BEEN_CONFIGURED
export_and_report GMU_PERM_BASIC_BOOTSTRAP_OPERATIONS_HAVE_BEEN_PERFORMED
export_and_report GMU_PERM_DROPBOX_HAS_BEEN_CONFIGURED
export_and_report GMU_PERM_DROPBOX_USER_WANTS_IT
export_and_report GMU_PERM_FINDER_SHOW_DRIVES_ON_DESKTOP
export_and_report GMU_PERM_INTRO_QUESTIONS_ASKED_AND_ANSWERED
export_and_report GMU_PERM_KEYBOARD_MAESTRO_HAS_BEEN_CONFIGURED
export_and_report GMU_PERM_MICROSOFT_WORD_HAS_BEEN_AUTHENTICATED
export_and_report GMU_PERM_MICROSOFT_WORD_HAS_BEEN_CONFIGURED
export_and_report GMU_PERM_MICROSOFT_WORD_USER_WANTS_IT
export_and_report GMU_PERM_TEXTEXPANDER_HAS_BEEN_CONFIGURED

export_and_report GMU_SESH_BASIC_IDEMPOTENT_SETTINGS_HAVE_BEEN_IMPLEMENTED
export_and_report GMU_SESH_DOTFILES_HAVE_BEEN_STOWED
export_and_report GMU_SESH_FINDER_SHOW_DRIVES_ON_DESKTOP_HAS_BEEN_IMPLEMENTED
export_and_report GMU_SESH_REACHED_FINALITY
export_and_report GMU_SESH_SESSION_HAS_STARTED
