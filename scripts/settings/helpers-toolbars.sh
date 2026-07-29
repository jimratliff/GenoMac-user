#!/usr/bin/env zsh

############### Helpers for configuring toolbars

function bomb_if_toolbar_configuration_does_not_exist() {
  local plist_path="$1"
  local toolbar_name="$2"

  local toolbar_path=":${toolbar_name}"

  if ! "${PLISTBUDDY_PATH}" \
    -c "Print '${toolbar_path}'" \
    "${plist_path}" >/dev/null 2>&1; then
    report_fail \
      "Required toolbar configuration does not exist: ${toolbar_name}${NEWLINE}Preferences plist: ${plist_path}"
  fi
}

function set_toolbar_property() {
  local plist_path="$1"
  local toolbar_name="$2"
  local property_name="$3"
  local property_type="$4"
  local property_value="$5"

  local property_path=":${toolbar_name}:${property_name}"

  bomb_if_toolbar_configuration_does_not_exist \
    "${plist_path}" \
    "${toolbar_name}"

  # Update the property if it exists, otherwise create it.
  if ! "${PLISTBUDDY_PATH}" \
    -c "Set '${property_path}' '${property_value}'" \
    "${plist_path}" 2>/dev/null; then
    "${PLISTBUDDY_PATH}" \
      -c "Add '${property_path}' ${property_type} '${property_value}'" \
      "${plist_path}"
  fi
}

function set_toolbar_to_show_both_icons_and_text() {
  local plist_path="$1"
  local toolbar_name="$2"

  set_toolbar_property \
    "${plist_path}" \
    "${toolbar_name}" \
    "TB Display Mode" \
    integer \
    1
}

function set_toolbar_items() {
  local plist_path="$1"
  local toolbar_name="$2"
  shift 2

  local items_path=":${toolbar_name}:TB Item Identifiers"
  local item
  local index=0

  bomb_if_toolbar_configuration_does_not_exist \
    "${plist_path}" \
    "${toolbar_name}"

  "${PLISTBUDDY_PATH}" \
    -c "Delete '${items_path}'" \
    "${plist_path}" 2>/dev/null || true

  "${PLISTBUDDY_PATH}" \
    -c "Add '${items_path}' array" \
    "${plist_path}"

  for item in "$@"; do
    "${PLISTBUDDY_PATH}" \
      -c "Add '${items_path}:${index}' string '${item}'" \
      "${plist_path}"

    (( ++index ))
  done
}
