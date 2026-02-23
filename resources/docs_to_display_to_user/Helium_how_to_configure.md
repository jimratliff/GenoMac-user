# How to configure the Helium web browser

## Why am I doing this interactively?
Unlike other Mac apps and even, for example, the Waterfox browser, as far as I’ve been able
to determine in my abbreviated investigation, Helium doesn’t expose its setting to scripting
in a sufficiently easy-to-deduce way. (Helium won’t be my daily driver. Instead, it’s what
I’ll use when I need to use a Chromium browser.)

## Make Helium active
- ❑ Make Helium active
  - The script will already have opened the Helium application for you.
 
## Initial splash screen
- If this is literally the first time this user has launched Helium, you’ll see a splash screen that
  asks you whether you (a) want to accept the defaults or (b) configure.
  - ❑ Choose “Defaults” (though this may not matter[^MAYBE_CONFIGURE_INSTEAD])
 
[^MAYBE_CONFIGURE_INSTEAD]: This is worth checking the next time I configure a pristine user. I had
assumed that “Configure” meant (a) avoiding all defaults and (b) start from scratch. That presumption
might have been incorrect. It might just be asking me whether (a) I wanted to accept the defaults
vis-à-vis (b) I wanted to build upon the defaults.

## Make selections from the View menu of the menubar
Select:
- ❑ View » Always Show Bookmarks Bar
- ❑ View » Always Show Full URLs

## Adjust some Settings
- ❑ From the application menubar, choose Helium » Settings… (⌘,)

### Search engine
- ❑ Click on “Search engine” in the left sidebar of Settings, or go to [helium://settings/search]
  - A new page will be displayed titled “Search engine”, showing the default engine of DuckDuckGo
- ❑ Click the “Change” button
  - A dialog box will open listing Microsoft Bing, Ecosia, …, Google, DuckDuckGo, etc.
- ❑ Select “Google” and click “Set as Default”

### On startup
- ❑ Click on “On startup” in the left sidebar of Settings, or go to [helium://settings/onStartup]
  - A new page will be displayed titled “On startup”, showing the default setting of “Open the New Tab page”
- ❑ Select “Continue where you left off”

## Return to the terminal
Now return to the terminal and acknowledge you have completed the configuration of Helium.
