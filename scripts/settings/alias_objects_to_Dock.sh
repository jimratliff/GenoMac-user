#!/usr/bin/env zsh

function conditionally_create_user_specified_Finder_alias_files_in_Dock_folder() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_OBJECTS_HAVE_BEEN_ALIASED_TO_DOCK" \
    create_user_specified_Finder_alias_files_in_Dock_folder_if_specified \
    "Skipping creating Finder alias files in the Dock’s aliases folder, because this was done in the past."
  
  report_end_phase_standard
}

function create_user_specified_Finder_alias_files_in_Dock_folder_if_specified() {
  # Alias specified objects to the Dock’s aliases folder (DIRECTORY_OF_ALIASES_FOR_DOCK).
  # Looks for a user-specific specification in a .jsonl file (USER_SPECIFIC_OBJECTS_TO_ALIAS_TO_THE_DOCK_FILE).
  # If not present, does nothing.
  #
  # HINT: DIRECTORY_OF_ALIASES_FOR_DOCK="$HOME/Documents/Aliases_for_Dock"
  # HINT: USER_SPECIFIC_OBJECTS_TO_ALIAS_TO_THE_DOCK_FILENAME="objects_to_alias_to_the_Dock.jsonl"
  # HINT: USER_SPECIFIC_OBJECTS_TO_ALIAS_TO_THE_DOCK_FILE="~/…/Dropbox/Users/$USER/Meta/objects_to_alias_to_the_Dock.jsonl"

  report_start_phase_standard

  local file_to_read="$USER_SPECIFIC_OBJECTS_TO_ALIAS_TO_THE_DOCK_FILE"

  local -a tuples

  # Looks for user-specific alias-to-Dock specifications
  if ! file_exists_and_is_readable "$file_to_read"; then
    report_to_log "Skipping aliasing objects to the Dock’s folder, because no user-specific specification file was found at “${file_to_read}”."
    report_end_phase_standard
    return 0
  fi

  get_array_from_json_lines_file "$file_to_read" 								# GenoMac-shared/scripts/helpers-json.sh
  tuples=("${reply[@]}")
  
  alias_user_specific_objects_to_the_Dock_from_array_of_2_tuples "${tuples[@]}"
  
  report_end_phase_standard
}

function alias_user_specific_objects_to_the_Dock_from_array_of_2_tuples() {
  # Create Finder alias files in Dock’s folder using supplied JSON-encoded (nickname, filesystem-path) tuples.
  #
  # Usage:
  #   alias_user_specific_objects_to_the_Dock_from_array_of_2_tuples "${tuples[@]}"
  #
  # Example of JSON-encoded tuples:
  #   DOCK_ACCESSIBLE_OBJECTS=(
  #     "[\"My Projects\", \"~/Documents/Projects\"]"
  #     "[\"Key spreadsheet\", \"~/Documents/Finance/bank_transaction.xls\"]"
  #   )

  report_start_phase_standard

  local -a supplied_tuples=("$@")

  local directory_of_aliases
  local index
  local nickname
  local original_filesystem_path
  local path_for_Finder_alias_file
  local tuple
  
  local -a nicknames=()
  local -a original_filesystem_paths=()
  local -a paths_for_Finder_alias_files=()
  
  local -A nicknames_previously_seen=()

  # An empty supplied array causes normal exit.
  if (( ${#supplied_tuples[@]} == 0 )); then
    report_warning "Array of objects to alias to Dock is empty. Moving on…."
    report_end_phase_standard
    return 0
  fi

  directory_of_aliases="$DIRECTORY_OF_ALIASES_FOR_DOCK"

  # Validate all (nickname, original_filesystem_path) pairs before creating aliases
  for tuple in "${supplied_tuples[@]}"; do

    parse_and_validate_json_2_tuple_of_nonempty_strings "$tuple"
    
    nickname="${reply[1]}"
    validate_string_as_a_filename "$nickname"
    if [[ -n "${nicknames_previously_seen[$nickname]-}" ]]; then
      report_fail "Attempt to create a Finder alias file with a duplicate nickname: ${nickname}"
      return 1
    fi
    nicknames_previously_seen[$nickname]=1
    nicknames+=("$nickname")
    
    original_filesystem_path="${reply[2]}"
    original_filesystem_path="$(expand_user_home_in_filesystem_path "$original_filesystem_path")"
    if [[ ! -e "$original_filesystem_path" ]]; then
      report_fail "Finder alias file’s target does not exist: $original_filesystem_path"
      return 1
    fi
    original_filesystem_paths+=("$original_filesystem_path")

    path_for_Finder_alias_file="${directory_of_aliases}/${nickname}"
    if [[ -e "$path_for_Finder_alias_file" || -L "$path_for_Finder_alias_file" ]]; then
      report_fail "I won’t create Finder alias file because an item already exists at: ${path_for_Finder_alias_file}"
      return 1
    fi
    paths_for_Finder_alias_files+=("$path_for_Finder_alias_file")
	
  done

  # Create Finder alias files in DIRECTORY_OF_ALIASES_FOR_DOCK (a) pointing to original_filesystem_path
  # and (b) named with desired nickname
	
  mkdir -p -- "$directory_of_aliases"
  
  for (( index = 1; index <= ${#nicknames[@]}; ++index )); do
  
    # nickname="${nicknames[$index]}"
	
    original_filesystem_path="${original_filesystem_paths[$index]}"
    path_for_Finder_alias_file="${paths_for_Finder_alias_files[$index]}"
    
    create_Finder_alias_file \
      --path_of_original "$original_filesystem_path" \
      --path_of_alias_file "$path_for_Finder_alias_file"
    
  done

  report_end_phase_standard
}
