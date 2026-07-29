#!/usr/bin/env zsh

############### Helpers for configuring toolbars

function set_toolbar_to_show_icons_and_text() {
  local plist="$1"
  local toolbar_name="$2"

  set_toolbar_property \
    "${plist}" \
    "${toolbar_name}" \
    "TB Display Mode" \
    integer \
    1
}

function set_toolbar_items_showing_icons_and_text() {
  local plist="$1"
  local toolbar_name="$2"
  shift 2

  set_toolbar_property \
    "${plist}" \
    "${toolbar_name}" \
    "TB Display Mode" \
    integer \
    1

  set_toolbar_items \
    "${plist}" \
    "${toolbar_name}" \
    "$@"
}

function set_toolbar_property() {
  local plist="$1"
  local toolbar_name="$2"
  local property_name="$3"
  local property_type="$4"
  local property_value="$5"

  local plistbuddy="/usr/libexec/PlistBuddy"
  local property_path=":${toolbar_name}:${property_name}"

  if ! "${plistbuddy}" \
    -c "Set '${property_path}' '${property_value}'" \
    "${plist}" 2>/dev/null; then
    "${plistbuddy}" \
      -c "Add '${property_path}' ${property_type} '${property_value}'" \
      "${plist}"
  fi
}

function set_toolbar_items() {
  local plist="$1"
  local toolbar_name="$2"
  shift 2

  local plistbuddy="/usr/libexec/PlistBuddy"
  local items_path=":${toolbar_name}:TB Item Identifiers"
  local item
  local index=0

  "${plistbuddy}" \
    -c "Delete '${items_path}'" \
    "${plist}" 2>/dev/null || true

  "${plistbuddy}" \
    -c "Add '${items_path}' array" \
    "${plist}"

  for item in "$@"; do
    "${plistbuddy}" \
      -c "Add '${items_path}:${index}' string '${item}'" \
      "${plist}"

    (( ++index ))
  done
}
