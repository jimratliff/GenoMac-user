# This file assumes GENOMAC_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_HELPER_DIR is not set. Please source `initial_prefs.sh` first."
  return 1
fi

source "${GENOMAC_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function find_diff_from_setting_change(){

# Relies on the environment variable GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS having been set

# Original source: Yann Bertrand and Oliver Mannion, 
# https://github.com/yannbertrand/macos-defaults/blob/main/diff.sh

# Prompt for diff name
# echo -n $'\e[1m❓ Insert diff name (to store it for future usage)\e[0m '
ask_question "Choose a name for this detective exercise:"
read name
name=${name:-default}

results_dir="${GENOMAC_USER_LOCAL_DEFAULTS_DETECTIVE_RESULTS}/${name}"

# Inform about save location
# echo $'\e[1mSaving plist files to '\'''"$(pwd)/diffs/${name}"$'\'' folder.\e[0m'
report "I’m saving the plist files to: '$results_dir'"

# Create destination and save initial plist snapshots
# mkdir -p "diffs/$name"
mkdir -p "$results_dir"
# defaults read > "diffs/$name/old.plist"
defaults read > "${results_dir}/old.plist"
# defaults -currentHost read > "diffs/$name/host-old.plist"
defaults -currentHost read > "${results_dir}/host-old.plist"

# Prompt to proceed
echo $'\n\e[1m⏳ Change settings and press any key to continue\e[0m'
read -n 1 -s -r

# Save new plist snapshots
defaults read > "diffs/$name/new.plist"
defaults -currentHost read > "diffs/$name/host-new.plist"

# Show diffs
echo $'\e[1m➡️ Here is your diff\e[0m\n'
git --no-pager diff --no-index "diffs/$name/old.plist" "diffs/$name/new.plist"

echo $'\n\n\e[1m➡️ and here with the `-currentHost` option\e[0m\n'
git --no-pager diff --no-index "diffs/$name/host-old.plist" "diffs/$name/host-new.plist"

# Reminder of how to rerun diffs
echo $'\n\n\e[1m🔮 Commands to print the diffs again\e[0m'
echo "\$ git --no-pager diff --no-index diffs/${name}/old.plist diffs/${name}/new.plist"
echo "\$ git --no-pager diff --no-index diffs/${name}/host-old.plist diffs/${name}/host-new.plist"

}
