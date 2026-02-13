// GenoMac-user modifications to Waterfox user preferences
// The master copy of this file is located at:
//   GenoMac-user/resources/waterfox
//
// NOTE: FAIL. The following was intended to change the default search engine to Google,
//       but it didn’t work.
//         // Search » Default search engine: Google
//         user_pref("browser.urlbar.placeholderName", "Google");

// General » Always check if Waterfox is your default browser? NO
user_pref("browser.shell.checkDefaultBrowser", false);

// General » Tabs » Open links in tabs instead of new windows? NO!
user_pref("browser.link.open_newwindow", 2);

// General » Tabs » Ask before closing multiple tabs? NO
user_pref("browser.tabs.warnOnClose", false);

// General » Tab Context Menu » Show copy all tab urls menu item? YES
user_pref("browser.tabs.copyallurls", true);

// General » Language and Appearance » Fonts » Default font: Palatino
user_pref("font.name.serif.x-western", "Palatino");

// General » Language and Appearance » Status Bar » Show Status Bar: YES
user_pref("browser.statusbar.enabled", true);

// General » Files and Applications » Applications » What should Waterfox do with other files? Save, don't ask
user_pref("browser.download.always_ask_before_handling_new_types", false);

// General » Browsing » Enable Picture-in-Picture video controls? NO
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

// Home » Homepage and new windows » Blank Page
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");

// Home » New Tabs » Blank Page
user_pref("browser.newtabpage.enabled", false);

// Privacy & Security » WebRTC peer connection » Do NOT enable WebRTC peer connection
user_pref("media.peerconnection.enabled", false);

// Privacy & Security » Passwords » Ask to save passwords? NO
user_pref("signon.rememberSignons", false);

// Privacy & Security » Passwords » Fill usernames and passwords automatically? NO
user_pref("signon.autofillForms", false);

// Privacy & Security » Passwords » Suggest strong passwords? NO
user_pref("signon.generation.enabled", false);

// Privacy & Security » Autofill » Do NOT save and fill addresses
user_pref("extensions.formautofill.addresses.enabled", false);

// Privacy & Security » Autofill » Do NOT save and fill payment methods
user_pref("extensions.formautofill.creditCards.enabled", false);

// Privacy & Security » Security » Enable HTTPS-Only Mode in all windows
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

// Look & Feel » Icons » Show Mac menu icons
user_pref("userChrome.icon.global_menu.mac", true);
