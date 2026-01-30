#!/usr/bin/env zsh

# Determines before-and-after changes to defaults domains as a result of
# change(s) to preferences.
#
# Relies

# Fail early on unset variables or command failure
set -euo pipefail

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

function find_diff_from_setting_change(){

	# Saves pre-change `defaults read` output, pausing for user to make the desired change(s) in
	# preferences.
	# After user indicates they’re finished, saves post-change `defaults read` output.
	# Then displays `diff` of the two files.
	#
	# Usage: 
	# - Run script
	# - Make the change(s) in preferences for which you’re searching for the corresponding 
	#   `defaults write` command(s)
	# - Hit any key to signal that you’ve completed making the change(s)
	# - The script will output *two* sets of diffs: (a) global for the user, i.e., for all hosts and
	#   (b) limited to `-currentHost`
	# - Observe produced diffs, which will show you the *key(s)* that have changed
	#   - Note: Some changes in key will be inconsequential/irrelevant. You’ll need judgement to 
	#     know to ignore them.
	# - The observed diff won’t tell you the *domain* of the changed key(s). For that use either:
	#     `defaults find *key*`
	#     `defaults -currentHost find *key*`
	# - The observed diff won’t tell the *type* of the changed domain/key pairs. For that use either:
	#     `defaults read-type *domain* *key*` or
	#     `defaults -currentHost read-type *domain* *key*`
	
	# Relies on the environment variable GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS having been set
	# in assign_environment_variables.sh. This is the directory in which the results of the 
	# `defaults read` of each branch of the before-and-after experiment will be stored.
	# (Most of the time you won’t need to access directly the contents of that directory, and this 
	# directory can be deleted at the send of a detective session. This is why the directory is not
	# hidden.)
	
	# Original source: Yann Bertrand and Oliver Mannion, 
	# https://github.com/yannbertrand/macos-defaults/blob/main/diff.sh
	
	report_start_phase_standard
	
	# Prompt for diff name
	name=$(get_nonblank_answer_to_question "Choose a name for this detective exercise:")
	
	timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
	results_dir="${GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS}/$(sanitize_filename "$name"_${timestamp})"
	
	# Inform about save location
	report "I’m saving the before-and-after 'defaults read' output files to: '$results_dir'"
	
	# Create destination and save initial `defaults read` snapshots
	
	report_action_taken "Creating snapshot directory, if necessary"
	mkdir -p "$results_dir" ; success_or_not
	
	report_action_taken "Reading pre-change defaults (not host specific)"
	defaults read > "${results_dir}/old.plist" ; success_or_not
	
	report_action_taken "Reading pre-change defaults (for '-currentHost')"
	defaults -currentHost read > "${results_dir}/host-old.plist" ; success_or_not
	
	# Prompt to proceed
	echo $'\n\e[1m⏳ Change settings and press any key to continue\e[0m'
	read -k1
	
	# Save new plist snapshots
	
	report_action_taken "Reading post-change defaults (not host specific)"
	defaults read > "${results_dir}/new.plist" ; success_or_not
	
	report_action_taken "Reading post-change defaults (for '-currentHost')"
	defaults -currentHost read > "${results_dir}/host-new.plist" ; success_or_not
	
	# Show diffs
	report "Here is your diff (not specific to a host):"
	git --no-pager diff --no-index "${results_dir}/old.plist" "${results_dir}/new.plist" || true
	
	report $"\n\n\nHere is your diff with '--currentHost':"
	git --no-pager diff --no-index "${results_dir}/host-old.plist" "${results_dir}/host-new.plist" || true
	
	report "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	report "💡 Tip: To investigate any changed keys, try:"
	echo "   To find the <domain> for <key>:"
	echo "   defaults find <key>"
	echo "   defaults -currentHost find <key>"
	echo "   To find the type of <domain> <key>:"
	echo "   defaults read-type <domain> <key>"
	echo "   defaults -currentHost read-type <domain> <key>"
	report "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	
	# Reminder of how to rerun diffs
	report "\n\n\n💡 Here are the commands if you want to see the diffs again:"
	echo "\$ git --no-pager diff --no-index ${results_dir}/old.plist ${results_dir}/new.plist"
	echo "\$ git --no-pager diff --no-index ${results_dir}/host-old.plist ${results_dir}/host-new.plist"
	
	report_end_phase_standard
}

function main() {
  find_diff_from_setting_change
}

main
