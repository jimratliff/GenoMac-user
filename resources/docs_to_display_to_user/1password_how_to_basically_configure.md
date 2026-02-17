# How to basically configure youru 1Password app
“Basic configuration” covers everything except for the Developer section of 1Password’s settings.

## Why do I have to do this myself?
In its obsession with security, the 1Password app erects obstacles to the programmatic setting of
preferences. (Every setting I’ve tested has a companion `authTag` key-value pair, where the value is
a hash-based message-authentication code. This prevents me from “tampering” with the preferences
using a script.)

## Make 1Password active and open its Settings
- ❑ Make 1Password active. (GenoMac-user will have already launched 1Password).
- ❑ Open 1Password’s Settings… (⌘,)

## Make the following changes to the out-of-the-box default settings

### General
- “Prefill username when creating a new login”
  - ❑ Change from ✅ → ❌
#### Keyboard Shortcuts
- “Show Quick Access”
  - ❑ Change to ⌃⌥⌘]
- “Lock 1Password”
  - ❑ REMOVE SHORTCUT
- “Autofill”
  - ❑ Change to ⌃⌥⌘.
### Appearance
#### Always Show in Sidebar
- Categories
  - ❑ Change from ❌ → ✅
- Tags
  - ❑ Change from ✅ → ❌
### Security
#### Unlock
- “Unlock using Touch ID”
  - ❑ Change from ❌ → ✅
- “Require password after”
  - ❑ Set at **14 days**
#### Auto-lock
- “Lock after the device is idle for”
- ❑ Change from 1 hour → **8 hours**
#### Concealed Fields
- “Hold Option to toggle revealed fields”
- ❑ Change from ❌ → ✅

## Return to the terminal
Now return to the terminal and acknowledge you have completed the basic configuration of 1Password.
