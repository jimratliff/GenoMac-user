#!/bin/zsh
set -euo pipefail

domain='com.ideabridge.spacejump'
plist="$HOME/Library/Preferences/$domain.plist"

names=(
  'Email, news, Dicord'
  'Reading-Coursework A'
  'Reading-Coursework B'
  'Tactics training'
  'Opening drilling'
  'Repertoire—White'
  'Repertoire—Black'
  'Game analysis (old school)'
  'Game analysis (silicon)'
  'Oppo research'
  'Ad hoc'
  'Tournament logistics'
  'Scoresheet prep'
  'HCEPro beta testing'
  'Database administration'
  'This Mac'
)

# Extract the plist Data value. `plutil ... raw` returns it as Base64.
current_json=$(
  plutil -extract spaceNamesByID raw "$plist" |
    base64 -D
)

# Show the current UUID/name order before changing anything.
print 'Current SpaceJump entries:'
print -rn -- "$current_json" |
  jq -r 'to_entries | to_entries[] |
         "\(.key + 1): \(.value.key) = \(.value.value)"'

key_count=$(print -rn -- "$current_json" | jq 'length')

print
read -q 'REPLY?Does that order match Spaces 1–16? Continue? [y/N] ' || {
  print
  exit 1
}
print

if (( key_count != ${#names[@]} )); then
  print -u2 "Refusing to write: SpaceJump has $key_count entries, but ${#names[@]} names were supplied."
  exit 1
fi

names_json=$(jq -cn --args '$ARGS.positional' -- "${names[@]}")

# Retain each UUID and replace its value by position.
new_json=$(
  print -rn -- "$current_json" |
    jq -c --argjson names "$names_json" '
      keys_unsorted as $keys |
      reduce range(0; $keys | length) as $i
        ({}; .[$keys[$i]] = $names[$i])
    '
)

# `defaults write -data` expects hexadecimal bytes.
hex_data=$(print -rn -- "$new_json" | xxd -p -c 0)

defaults write "$domain" spaceNamesByID -data "$hex_data"

print 'SpaceJump names written successfully.'
