#!/bin/zsh

GENOMAC_USER_LOCAL_MICROSOFT_WORD_RESOURCE_DIRECTORY="$GENOMAC_USER_LOCAL_RESOURCE_DIRECTORY/microsoft_word"

function set_microsoft_word_settings() {

  # Main function for implementing Microsoft Word settings (after determining that it should be done).
  #
  # Microsoft Word exposes very few settings through the traditional `defaults write` API.
  # As a result, most settings are implemented through a combination of:
  # - Installing a preconfigured Normal.dotm file
  # - Using a VBA macro to reach the settings that `defaults write` doesn’t reach.
  #
  # Because running the VBA macro involves Word launching (and sometimes, at least, dialogs asking
  # for permission pop up), executing this function is much more demanding on the executing user’s
  # work flow.
  #
  # As a result, this function is considered a BOOTSTRAP step, not an idempotent, maintenance step.
  #
  # This policy finds expression in `run_hypervisior.sh`, where the state environment variables
  # associated with the configuration of Microsoft Word are `GMU_PERM_` rather than `GMU_SESH_`.

  report_start_phase_standard
  
  local domain="com.microsoft.Word"
  
  report_action_taken "Set some Microsoft Word preferences with defaults write command(s)"
  report_adjust_setting "Ribbon: Show group titles"
  defaults write "${domain}" OUIRibbonShowGroupTitles -bool true ; success_or_not
  
  report_action_taken "Install Microsoft Word’s global template file Normal.dotm"
  install_microsoft_word_normal_dotm ; success_or_not
  
  report_action_taken "Use a VBA script to implement additional Microsoft Word preferences"
  run_vba_script_to_implement_microsoft_word_preferences
  
  report_end_phase_standard

}

function install_microsoft_word_normal_dotm() {
  # Installs a custom Normal.dotm file.
  # The pre-configured Normal.dotm file is assumed to available in this repo at: 
  #   resources/microsoft_word/normal_dotm
  
  report_start_phase_standard

  local global_template_filename="Normal.dotm"
  local path_for_Microsoft_Word_templates="${HOME}/Library/Group Containers/UBF8T346G9.Office/User Content.localized/Templates.localized"

  local source_path="${GENOMAC_USER_LOCAL_MICROSOFT_WORD_RESOURCE_DIRECTORY}/normal_dotm/${global_template_filename}"
  local destination_path="${path_for_Microsoft_Word_templates}/${global_template_filename}"

  report_action_taken "Installing global template Normal.dotm into sandboxed location"
  copy_resource_between_local_directories "$source_path" "$destination_path" ; success_or_not

  report_end_phase_standard
}

function run_vba_script_to_implement_microsoft_word_preferences() {
  report_start_phase_standard

  local Word_document_filename="Container_for_VBA_macro_to_set_Word_preferences.docm"
  local MICROSOFT_WORD_SANDBOX_HOME="$HOME/Library/Containers/com.microsoft.Word/Data"
  local TEMP_DIRECTORY_FOR_MICROSOFT_WORD="$MICROSOFT_WORD_SANDBOX_HOME/tmp/genomac"

  # Construct path to macro-containing Word file
  local source_path="${GENOMAC_USER_LOCAL_MICROSOFT_WORD_RESOURCE_DIRECTORY}/VBA_script/${Word_document_filename}"

  # NOTE: The below log-file filename and path are *not* discretionary. 
  # They are hardwired into the VBA macro, see, e.g., $Word_document_filename
  local log_file_file_name="word_preferences_log.txt"
  local log_file_from_VBA_macro="${TEMP_DIRECTORY_FOR_MICROSOFT_WORD}/${log_file_file_name}"

  # Confirm existence of macro-containing Word file
  if [[ ! -f "$source_path" ]]; then
    report_fail "Missing macro-containing Word document at ${source_path}"
    exit 1
  fi
  report_success "Macro-containing Word document found at ${source_path}"
  
  report_action_taken "Create, if necessary, temporary directory at ${TEMP_DIRECTORY_FOR_MICROSOFT_WORD}"
  mkdir -p "$TEMP_DIRECTORY_FOR_MICROSOFT_WORD"
  if [[ -d "$TEMP_DIRECTORY_FOR_MICROSOFT_WORD" ]]; then
      report_success "Created ${TEMP_DIRECTORY_FOR_MICROSOFT_WORD}"
  else
      report_fail "Failed to create directory at ${TEMP_DIRECTORY_FOR_MICROSOFT_WORD}"
      exit 1
  fi
  
  report_action_taken "Remove, if necessary, any stale log file from a previous run"
  rm -f "$log_file_from_VBA_macro" ; success_or_not
  
  # Open the document in Word (this triggers Document_Open → SetMyPreferences)
  report_action_taken "Opening in Word the macro-containing Word document in order to launch its preferences-setting macro"
  report_warning "A dialog will pop up: You must agree to “Enable Macros”"
  open -a "Microsoft Word" "$source_path"
  success_or_not
  
  # Wait for the log file to appear (indicates macro completed)
  report_action_taken "Waiting for Word macro to complete (approve macro dialog if prompted)"
  local max_elapsed=200
  local warning_threshold=30
  local elapsed=0
  local warning_shown=false
  
  while [[ ! -f "$log_file_from_VBA_macro" ]]; do
    sleep 1
    elapsed=$((elapsed + 1))
    
    if [[ $elapsed -lt $warning_threshold ]]; then
      # Print timer emoji on same line (no newline)
      printf "⏲ "
    elif [[ "$warning_shown" == "false" ]]; then
      echo ""  # Newline after the timer emojis
      report_warning "STILL WAITING FOR WORD MACRO TO COMPLETE. (Did you agree to enable macros?) Hit Control-C to abort."
      warning_shown=true
    fi
  done
  
  echo ""  # Newline after timer emojis if we exit before warning
  
  # Brief additional wait to ensure file is fully written
  sleep 1
  
  # Report results
  if [[ -f "$log_file_from_VBA_macro" ]]; then
    # Optionally echo the log contents or parse for status
    report "Here is a summary of actions taken by the VBA macro:"
    cat "$log_file_from_VBA_macro"
    success_or_not
  else
    report_fail "Word preferences macro did not complete within ${timeout}s"
    exit 1
  fi
  report_end_phase_standard
}
