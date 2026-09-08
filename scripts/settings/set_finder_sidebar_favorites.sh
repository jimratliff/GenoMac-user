#!/usr/bin/env zsh

function conditionally_bootstrap_finder_sidebar_favorites_for_barebones_user() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_FINDER_SIDEBAR_HAS_BEEN_ARRANGED_FOR_BOOTSTRAP_USER" \
    bootstrap_user_finder_sidebar_favorites_for_barebones_user \
    "Skipping setting Finder sidebar Favorites items for barebones user, because this was done in the past."
  
  report_end_phase_standard
}

function conditionally_set_user_finder_sidebar_favorites() {
  report_start_phase_standard

  run_if_user_has_not_done \
    "$PERM_FINDER_SIDEBAR_HAS_BEEN_ARRANGED" \
    set_user_finder_sidebar_favorites \
    "Skipping setting Finder sidebar Favorites items, because this was done in the past."
  
  report_end_phase_standard
}

function bootstrap_user_finder_sidebar_favorites_for_barebones_user() {
  # Bootstraps Finder sidebar favorites for barebones user
  report_start_phase_standard

  set_user_finder_sidebar_favorites_from_array_of_2_tuples "${FINDER_SIDEBAR_FAVORITES_BAREBONES[@]}"
  
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
    report_to_log "Setting default Finder sidebar Favorites, because no user-specific specification file was found at “${file_to_read}”."
    bootstrap_user_finder_sidebar_favorites_for_barebones_user
    report_end_phase_standard
    return 0
  fi

  get_array_from_json_lines_file "$file_to_read"
  tuples=("${reply[@]}")
  set_user_finder_sidebar_favorites_from_array_of_2_tuples "${tuples[@]}"
  
  report_end_phase_standard
}

function set_user_finder_sidebar_favorites_from_array_of_2_tuples() {
  # Replaces Finder sidebar Favorites using supplied JSON-encoded
  # [display-name, filesystem-path] tuples.
  #
  # Usage:
  #   set_user_finder_sidebar_favorites_from_array_of_2_tuples \
  #     "${favorites[@]}"

  report_start_phase_standard

  local -a supplied_tuples=("$@")
  local -a prepared_tuples=()

  local tuple
  local name
  local filesystem_path
  local file_url
  local prepared_tuple

  # An empty supplied array leaves the existing Favorites unchanged.
  if (( ${#supplied_tuples[@]} == 0 )); then
    report_to_log "Favorites array is empty. Leaving Favorites in Finder sidebar unchanged."
    report_end_phase_standard
    return 0
  fi

  # Validate and prepare all entries before clearing the sidebar.
  for tuple in "${supplied_tuples[@]}"; do
    if ! jq -e '
      type == "array"
      and length == 2
      and all(.[];
        type == "string" and length > 0
      )
    ' <<<"$tuple" >/dev/null
    then
      report_fail "Invalid Finder sidebar Favorite tuple: $tuple"
      return 1
    fi

    name="$(jq -r '.[0]' <<<"$tuple")"

    filesystem_path="$(jq -r '.[1]' <<<"$tuple")"

    file_url="$(convert_filesystem_path_to_file_url "$filesystem_path")"

    prepared_tuple="$(
      jq -cn \
        --arg name "$name" \
        --arg url "$file_url" \
        '[$name, $url]'
    )"

    prepared_tuples+=("$prepared_tuple")
  done

  # Remove all existing Favorites
  report_action_taken "Removing all existing Finder sidebar Favorites."
  finder_sidebar_favorites_remove_all ; success_or_not

  # Replace Favorites with new set
  for tuple in "${prepared_tuples[@]}"; do
    name="$(jq -r '.[0]' <<<"$tuple")"
    file_url="$(jq -r '.[1]' <<<"$tuple")"

    finder_sidebar_favorites_add_name_and_file_url "$name" "$file_url"
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
