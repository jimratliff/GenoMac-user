#!/usr/bin/env zsh

# Most of the git config are (a) defined at stow_directory/git/.config/git/config and
# (b) managed by GNU Stow.
#
# However, the [user] block, which contains the user’s name and email address are
# not expressed in that config file, in order that the name/email aren’t accidentally
# propagated to and inadvertently adopted by other users.
#
# Instead stow_directory/git/.config/git/config uses an [include] block to pull the name
# email address in from another file at GENOMAC_USER_GITCONFIG_OVERRIDE
# HINT: GENOMAC_USER_GITCONFIG_OVERRIDE: ~/.config/genomac-user/git/gitconfig-personal
#
# Note that, despite being located in ~/.config, this is not the result of symlinking by Stow.
# This file is *not* managed by GNU Stow and is not sourced from stow_directory.
#
# When determined, default values for name and email-address are stored as the *content* of
# the two *system*-domain state variables, respectively:
# - PERM_DEFAULT_GIT_USER_NAME
# - PERM_DEFAULT_GIT_USER_EMAIL

function conditionally_set_git_config_user() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_SUPPLEMENTAL_GIT_CONFIG_HAS_BEEN_SET" \
    set_git_config_user \
    "Skipping creating user’s supplemental git-config, because this was done in the past."
    
  report_end_phase_standard
}

function set_git_config_user() {
  # Creates file at GENOMAC_USER_GITCONFIG_OVERRIDE that contains a [user] block that is 
  # [include]-d by stow_directory/git/.config/git/config
  report_start_phase_standard

  

  report_end_phase_standard
}

function get_default_git_user_field_value() {
  # Get default value, if it exists, stored in first line of system state file in $1.
  # If the state file does not exist (a normal occurrence) return 1 to communicate it doesn’t exist.
  # Gets string from first line of the file, stripping leading/trailing whitespace.
  # Echo that string if nonempty.
  # If string is empty, return 1

  local system_state_for_default_value=$1

  if ! test_genomac_system_state "${system_state_for_default_value}"; then
    report "State $1 not present ⇒ No default value found."
    return 1
  fi

  local path_to_state_file
  path_to_state_file="$(_system_state_file_path "${system_state_for_default_value}")"

  local field_value
  # Gets first line (head -1) and strips leading/trailing whitespace (xargs)
  field_value=$(head -1 "$path_to_state_file" | xargs)

  if [[ -z "$field_value" ]]; then
    report_action_taken "State $1 existed but empty.${NEWLINE}Deleting state"
    delete_genomac_system_state "$1"
    return 1
  fi

  echo "$field_value"
}

function interactive_get_git_user_field_value() {

  report_start_phase_standard
  
  # field description is either "user" or "email address"
  local field_description=$1
  local system_state_for_default_value=$2

  local default_was_set=false
  local default_value
  local field_value

  if default_value=$(get_default_git_user_field_value "$system_state_for_default_value"); then
    default_was_set=true
  fi

  if $default_was_set; then
    report "I found this default value for the ${field_description} field for your Git profile: “${default_value}”"
	if get_yes_no_answer_to_question "Do you accept the default value?"; then
	  # Returns the default_value as the accepted answer
	  echo "$default_value"
	  report_end_phase_standard
	  return 0
	fi
  fi

  # Either no default answer or the default wasn’t accepted
  field_value=$(get_confirmed_answer_to_question "Enter the ${field_description} for your Git profile")

  # If there was no default value, offer to make the current answer the default for other users
  # This is the mechanism by which any default answer is set
  if ! $default_was_set; then
    if get_yes_no_answer_to_question "Would you like to make this the default value for other users?"; then
	  set_default_value_for_git_user_field "${field_value}" "${system_state_for_default_value}"
	fi
  fi

  echo "${field_value}"
  
  report_end_phase_standard
}

function set_default_value_for_git_user_field() {
  local value_for_field=$1
  local system_state_for_default_value=$2

  # requires sudo
  set_genomac_system_state "${system_state_for_default_value}"

  local path_to_state_file
  path_to_state_file="$(_system_state_file_path "${system_state_for_default_value}")"

  sudo echo "$value_for_field" > "$path_to_state_file"

  report_end_phase_standard
}

function resolve_git_user_field() {
  report_start_phase_standard
  local system_state_for_default_value=$1
  

  


  report_end_phase_standard
}

function write_gitconfig-personal() {
  # Writes a file at path $GENOMAC_USER_GITCONFIG_OVERRIDE containing a [user] block that 
  # overrides that block of the main gitconfig file.
  # Assumes that the main gitconfig file uses `[include]` to pull in this content.
  # HINT: GENOMAC_USER_GITCONFIG_OVERRIDE: ~/.config/genomac-user/git/gitconfig-personal

  report_start_phase_standard

  report_action_taken "Write auxiliary git config file with personalized name/email."
  
  local name="$1"
  local email="$2"

  mkdir -p "$(dirname "$GENOMAC_USER_GITCONFIG_OVERRIDE")"

  cat > "$GENOMAC_USER_GITCONFIG_OVERRIDE" <<EOF
[user]
	name = ${name}
	email = ${email}
EOF

  success_or_not
  report_end_phase_standard
}


