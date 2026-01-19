#!/usr/bin/env zs

set -euo pipefail

# Test Showing a doc with Quick Look

source "${HOME}/.genomac-user/scripts/0_initialize_me.sh"

report_action_taken "I am about to show you a Markdown document."

doc_to_show="${GENOMAC_USER_DOCS_TO_DISPLAY_DIRECTORY}/test.md"

show_file_using_quicklook "$doc_to_show"
