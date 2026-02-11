#!/usr/bin/env zsh

# Compile data for individual Gecko web-browser extensions to be downloaded and
# installed from addons.mozilla.org
# 
# NOTE: For each extension, there are two variables (a _SLUG and an _ID). Both must
#       be exported.
#
# For a new extension:
# 1. Finding the extension ID:
#    - OPTION A (without installing): Visit the extension’s page on addons.mozilla.org.
#      Right-click the "Add to Firefox" button and choose "Save Link As…" to download
#      the .xpi file. Open in BBEdit (or unzip it; it’s just a zip) and look at
#      manifest.json. The ID is in "browser_specific_settings.gecko.id" or sometimes
#      just "id" at the top level.
#    - OPTION B (after installing): Look in ~/Library/Application Support/Waterfox/Profiles/
#      *.default-release/extensions/ for the .xpi filename (minus the .xpi suffix).
#
# 2. Finding the slug (the key in this array):
#    - The slug comes from the addons.mozilla.org URL. For example:
#      https://addons.mozilla.org/en-US/firefox/addon/manage-my-tabs/
#                                                    ^^^^^^^^^^^^^^
#    - This slug is used to construct the download URL:
#      https://addons.mozilla.org/firefox/downloads/latest/<slug>/latest.xpi
#
# The naming convention is GECKO_EXTENSION_EXAMPLE_SLUG and GECKO_EXTENSION_EXAMPLE_ID,
# where EXAMPLE is an arbitrary GenoMac-internal identifier of the extension.

# The download URL for an extention is:
# "${PATH_TO_EXTENSION_SLUG_GECKO}/${slug}/latest.xpi"
PATH_TO_EXTENSION_SLUG_GECKO="https://addons.mozilla.org/firefox/downloads/latest"

# GECKO_EXTENSION_EXAMPLE_SLUG="string"
# GECKO_EXTENSION_EXAMPLE_ID="string"
# export_and_report GECKO_EXTENSION_EXAMPLE_SLUG
# export_and_report GECKO_EXTENSION_EXAMPLE_ID

GECKO_EXTENSION_1PASSWORD_SLUG="1password-x-password-manager"
GECKO_EXTENSION_1PASSWORD_ID="{d634138d-c276-4fc8-924b-40a0ea21d284}"

GECKO_EXTENSION_ALLOWRIGHTCLICK_SLUG="re-enable-right-click"
GECKO_EXTENSION_ALLOWRIGHTCLICK_ID="{278b0ae0-da9d-4cc6-be81-5aa7f3202672}"

GECKO_EXTENSION_CHESSVISIONAI_SLUG="chessvision-ai-for-firefox"
GECKO_EXTENSION_CHESSVISIONAI_ID="{ac1b5818-9b18-470f-91d8-c3a446e9cf87}"

GECKO_EXTENSION_CONSENTOMATIC_SLUG="consent-o-matic"
GECKO_EXTENSION_CONSENTOMATIC_ID="gdpr@cavi.au.dk"

GECKO_EXTENSION_DOWNIE_SLUG="downie-extension"
GECKO_EXTENSION_DOWNIE_ID="downie@charliemonroe.net"

GECKO_EXTENSION_MANAGEMYTABS_SLUG="manage-my-tabs"
GECKO_EXTENSION_MANAGEMYTABS_ID="{d3851178-4022-4b97-8746-08c051ba21bc}"

GECKO_EXTENSION_MULTIACCOUNTCONTAINERS_SLUG="multi-account-containers"
GECKO_EXTENSION_MULTIACCOUNTCONTAINERS_ID="@testpilot-containers"

GECKO_EXTENSION_RAINDROPIO_SLUG="raindropio"
GECKO_EXTENSION_RAINDROPIO_ID="jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack.xpi"

GECKO_EXTENSION_TABS2LIST_SLUG="tabs-2-list"
GECKO_EXTENSION_TABS2LIST_ID="TabsList@example.com"

GECKO_EXTENSION_TREESTYLETAB_SLUG="tree-style-tab"
GECKO_EXTENSION_TREESTYLETAB_ID="treestyletab@piro.sakura.ne.jp"

export_and_report PATH_TO_EXTENSION_SLUG_GECKO

export_and_report GECKO_EXTENSION_1PASSWORD_ID
export_and_report GECKO_EXTENSION_1PASSWORD_SLUG
export_and_report GECKO_EXTENSION_ALLOWRIGHTCLICK_ID
export_and_report GECKO_EXTENSION_ALLOWRIGHTCLICK_SLUG
export_and_report GECKO_EXTENSION_CHESSVISIONAI_ID
export_and_report GECKO_EXTENSION_CHESSVISIONAI_SLUG
export_and_report GECKO_EXTENSION_CONSENTOMATIC_ID
export_and_report GECKO_EXTENSION_CONSENTOMATIC_SLUG
export_and_report GECKO_EXTENSION_DOWNIE_ID
export_and_report GECKO_EXTENSION_DOWNIE_SLUG
export_and_report GECKO_EXTENSION_MANAGEMYTABS_ID
export_and_report GECKO_EXTENSION_MANAGEMYTABS_SLUG
export_and_report GECKO_EXTENSION_MULTIACCOUNTCONTAINERS_ID
export_and_report GECKO_EXTENSION_MULTIACCOUNTCONTAINERS_SLUG
export_and_report GECKO_EXTENSION_RAINDROPIO_ID
export_and_report GECKO_EXTENSION_RAINDROPIO_SLUG
export_and_report GECKO_EXTENSION_TABS2LIST_ID
export_and_report GECKO_EXTENSION_TABS2LIST_SLUG

