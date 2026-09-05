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
  # HINT: USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILENAME="finder_sidebar_favorites_name_path_pairs.json"
  # HINT: USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILE="${USER_SPECIFIC_META_DIRECTORY}/${USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILENAME}"
  report_start_phase_standard

  local file_to_read="$USER_SPECIFIC_FINDER_SIDEBAR_FAVORITES_FILE"

  local -a tuples

  if ! file_exists_and_is_readable "$file_to_read"; then
    report_to_log "Setting default Finder sidebar Favorites, because no user-specific specification file was found at “${file_to_read}”."
    set_user_finder_sidebar_favorites_from_array_of_2_tuples "${FINDER_SIDEBAR_FAVORITES_BAREBONES[@]}"
    report_end_phase_standard
    return 0
  fi

  get_array_of_2_tuples_from_json_file "$file_to_read"
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
  if ! mysides remove all; then
    report_fail "Unable to clear Finder sidebar Favorites; no items were added."
    return 1
  fi

  # Replace Favorites with new set
  for tuple in "${prepared_tuples[@]}"; do
    name="$(jq -r '.[0]' <<<"$tuple")"
    file_url="$(jq -r '.[1]' <<<"$tuple")"

    if ! mysides add "$name" "$file_url"; then
      report_warning "Unable to add Finder sidebar Favorite: $name"
    fi
  done

  report_end_phase_standard
}
