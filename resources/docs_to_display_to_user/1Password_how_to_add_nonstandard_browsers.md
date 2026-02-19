# How to permit 1Password to interoperate with nonstandard browsers, e.g., Waterfox, Helium
## Context
Out of the box, 1Password supports only the following the browsers: Chrome, Edge, Firefox,
Safari, Brave, and Arc.

But I need 1Password to treat other browsers (e.g., Waterfox, Helium) as first-class browser citizens.

## Make 1Password active
- ❑ Make 1Password active. (GenoMac-user will have already launched 1Password).

## Make the following changes to the out-of-the-box default settings

### Browser
#### Connect to additional browsers
There may, or may not, already be one or more nonstandard browsers listed in this section.

- ❑ Identify the nonstandard browsers you want to authorize for interoperation with
  1Password that are not already listed as having been authorized
- For each of these browsers:
  - ❑ Open 1Password’s Settings… (⌘,)
  - Click the “Add Browser” button, which opens an Open dialog pointing at /Applications
    - In the list of applications, double-click on the nonstandard browser you wish to authorize
  - 1Password will pop up a Touch ID authorization dialog: “Authorize the browser Waterfox to access 1Password”
  - Use Touch ID, or your 1Password password, to authorize this browser.
  - This will dismiss both (a) the authorization dialog *and* (b) the Settings/Browser settings tab.
  - Repeat for each nonstandard browser you want to authorize

## Return to the terminal
Now return to the terminal and acknowledge you have completed the basic configuration of 1Password.
