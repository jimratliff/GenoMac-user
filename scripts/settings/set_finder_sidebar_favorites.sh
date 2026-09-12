#!/usr/bin/env zsh

function conditionally_bootstrap_finder_sidebar_favorites_for_barebones_user() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_FINDER_SIDEBAR_HAS_BEEN_ARRANGED_FOR_BAREBONES_USER" \
    bootstrap_user_finder_sidebar_favorites_for_barebones_user \
    "Skipping setting Finder sidebar Favorites items for barebones user, because this was done in the past."
  
  report_end_phase_standard
}

function conditionally_set_user_finder_sidebar_favorites() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_FINDER_SIDEBAR_HAS_BEEN_ARRANGED_FOR_NONBAREBONES_USER" \
    set_user_finder_sidebar_favorites \
    "Skipping setting Finder sidebar Favorites items, because this was done in the past."
  
  report_end_phase_standard
}

function bootstrap_user_finder_sidebar_favorites_for_barebones_user() {
  # Bootstraps Finder sidebar favorites for barebones user
  report_start_phase_standard

  report_action_taken "Setting default Finder sidebar Favorites for barebones user."
  indirectly_set_user_finder_sidebar_favorites_from_array_of_2_tuples "${FINDER_SIDEBAR_FAVORITES_BAREBONES[@]}"
  
  report_end_phase_standard
}

function set_user_finder_sidebar_favorites() {
  # Implements Finder sidebar Favorites, looking first for a user-specific specification.
  # If not present, falls back to the default set of Favorites for a barebones user.
  #
  # HINT: USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILENAME="finder_sidebar_favorites_name_path_pairs.jsonl"
  # HINT: USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILE="${USER_SPECIFIC_META_DIRECTORY}/${USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILENAME}"
  report_start_phase_standard

  local file_to_read="$USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILE"

  local -a tuples

  # Looks for user-specific sidebar specifications; otherwise, fall back to defaults for barebones users.
  if ! file_exists_and_is_readable "$file_to_read"; then
    report_action_taken "Setting default Finder sidebar Favorites, because no user-specific specification file was found at “${file_to_read}”."
    bootstrap_user_finder_sidebar_favorites_for_barebones_user
    report_end_phase_standard
    return 0
  fi

  get_array_from_json_lines_file "$file_to_read" 								# GenoMac-shared/scripts/helpers-json.sh
  tuples=("${reply[@]}")
  
  indirectly_set_user_finder_sidebar_favorites_from_array_of_2_tuples "${tuples[@]}"
  
  report_end_phase_standard
}

function indirectly_set_user_finder_sidebar_favorites_from_array_of_2_tuples() {
  # Replaces Finder sidebar Favorites using supplied JSON-encoded (nickname, filesystem-path) tuples.
  #
  # macOS ignores (e.g., when using mysides) a separately specified nickname for a Finder sidebar
  # Favorite, using instead the filename part of the file’s path as the name displayed on the sidebar.
  #
  # To work around this, we first create a Finder alias file (in FINDER_SIDEBAR_ALIASES_FOLDER) pointing
  # to the desired filesystem-path but whose filename is the specified nickname.
  # Then we add that alias as the Finder’s sidebar Favorite, achieving indirectly (i.e., 
  # via an intermediate alias) the desired nickname to be displayed in Finder’s sidebar.
  #
  # Usage:
  #   indirectly_set_user_finder_sidebar_favorites_from_array_of_2_tuples "${favorites[@]}"
  #
  # Example of JSON-encoded tuples:
  #   FINDER_SIDEBAR_FAVORITES=(
  #     "[\"My apps\", \"/Applications\"]"
  #     "[\"Nerd apps\", \"/Applications/Utilities\"]"
  #     "[\"$USER\", \"~\"]"
  #     "[\"Don’t screw these up\", \"~/Library\"]"
  #     "[\"♟️ Chess\", \"~/Documents/HIARCS Chess\"]"
  #   )

  report_start_phase_standard

  local -a supplied_tuples=("$@")
  
  local index
  local nickname
  local file_url_for_Finder_alias_file
  local original_filesystem_path
  local path_for_Finder_alias_file
  local tuple
  
  local -a file_urls_for_Finder_alias_file=()
  local -a nicknames=()
  local -a original_filesystem_paths=()
  
  local -A nicknames_previously_seen=()

  # An empty supplied array leaves the existing Favorites unchanged.
  if (( ${#supplied_tuples[@]} == 0 )); then
    report_warning "Favorites array is empty. Leaving Favorites in Finder sidebar unchanged."
    report_end_phase_standard
    return 0
  fi

  # Validate all (nickname, original_filesystem_path) pairs before clearing existing aliases
  for tuple in "${supplied_tuples[@]}"; do

    parse_and_validate_json_2_tuple_of_nonempty_strings "$tuple"
    
    nickname="${reply[1]}"
    validate_string_as_a_filename "$nickname"
    if [[ -n "${nicknames_previously_seen[$nickname]-}" ]]; then
      report_fail "Attempt to create a Favorite with a duplicate nickname: ${nickname}"
      return 1
    fi
    nicknames_previously_seen[$nickname]=1
    nicknames+=("$nickname")
    
    original_filesystem_path="${reply[2]}"
    original_filesystem_path="$(expand_user_home_in_filesystem_path "$original_filesystem_path")"
    if [[ ! -e "$original_filesystem_path" ]]; then
      report_fail "Finder sidebar Favorite target does not exist: $original_filesystem_path"
      return 1
    fi
    original_filesystem_paths+=("$original_filesystem_path")
	
  done

	# Create Finder alias files in FINDER_SIDEBAR_ALIASES_FOLDER (a) pointing to original_filesystem_path
	# and (b) named with desired nickname
	
	mkdir -p "$FINDER_SIDEBAR_ALIASES_FOLDER"
  
  report_action_taken_to_log "Removing existing Finder alias files from Finder sidebar Favorites alias directory."
  remove_Finder_alias_files_from_directory "$FINDER_SIDEBAR_ALIASES_FOLDER"
  
  for (( index = 1; index <= ${#nicknames[@]}; ++index )); do
  
    nickname="${nicknames[$index]}"
    original_filesystem_path="${original_filesystem_paths[$index]}"
    
    path_for_Finder_alias_file="${FINDER_SIDEBAR_ALIASES_FOLDER}/${nickname}"
    
    create_Finder_alias_file \
      --path_of_original "$original_filesystem_path" \
      --path_of_alias_file "$path_for_Finder_alias_file"

    # Convert path to `file:` URL
    file_url_for_Finder_alias_file="$(convert_filesystem_path_to_file_url "$path_for_Finder_alias_file")"
    file_urls_for_Finder_alias_file+=("$file_url_for_Finder_alias_file")
    
  done

  report_action_taken_to_log "Removing all existing Finder sidebar Favorites."
  finder_sidebar_favorites_remove_all
  
  # Add Favorites to Finder’s sidebar
  for (( index = 1; index <= ${#nicknames[@]}; ++index )); do
    nickname="${nicknames[$index]}"
    report_to_log "Add “${nickname}” to Finder sidebar Favorites"
    finder_sidebar_favorites_add_name_and_file_url \
      "$nickname" \
      "${file_urls_for_Finder_alias_file[$index]}"
  done

  report_end_phase_standard
}

function finder_sidebar_favorites_remove_all() {
  # Remove all Finder sidebar Favorites.
  report_start_phase_standard
  report_to_log "Clearing all existing Finder sidebar Favorites."
  mysides remove all
  report_end_phase_standard
}

function finder_sidebar_favorites_add_name_and_file_url() {
  # Append Finder sidebar favorite defined by name and file_url.
  # Assumes mysides command is provided by https://github.com/jeremy4971/mysides-swift
  # NOTE: Although myside takes both a name and file-URL pair, macOS appears to ignore
  #       the supplied name, instead always showing on the sidebar the item’s actual name
  #       A workaround is to create an alias of the desired item, rename the alias to the
  #       desired item name, and add the alias to the sidebar (rather than adding the
  #       ultimate item to the sidebar).
  report_start_phase_standard
  
  local name_of_favorite="${1:?MISSING name}"
  local file_url="${2:?MISSING fileurl}"
  
  report_to_log "Appending Finder sidebar Favorite: $name_of_favorite : “${file_url}”"
  mysides add "$name_of_favorite" "$file_url"
  
  report_end_phase_standard
}
