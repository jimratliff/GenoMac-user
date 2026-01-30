#!/usr/bin/env zsh

set -euo pipefail

# Test Showing a doc with Quick Look

source "${HOME}/.genomac-user/scripts/0_initialize_me_first.sh"

report_action_taken "I am about to show you a Markdown document."

doc_to_show="${GMU_DOCS_TO_DISPLAY}/test.md"

show_file_using_quicklook "$doc_to_show"
