#!/usr/bin/env zsh

function set_omnioutliner_settings() {

  report_start_phase_standard
  report_action_taken "Implement OmniOutliner settings"

  local domain="com.omnigroup.OmniOutliner5.MacAppStore"

  local custom_template_filename="_JDR_OmniOutliner_Template.oo3template"

  # Construct full source path for this specific repo
  # local source_path="${GENOMAC_USER_LOCAL_DIRECTORY}/resources/omnioutliner/${custom_template_filename}"
  local source_path="${GENOMAC_USER_LOCAL_RESOURCE_DIRECTORY}/omnioutliner/${custom_template_filename}"

  # Construct destination path to OmniOutliner’s directory for custom templates
  local path_for_OO_preferences="${HOME}/Library/Containers/${domain}/Data/Library/Application Support/The Omni Group/OmniOutliner"
  local path_for_OO_custom_templates="${path_for_OO_preferences}/Pro Templates"
  local destination_path="${path_for_OO_custom_templates}/${custom_template_filename}"

  report_action_taken "Copy Jim’s custom OmniOutliner template to OmniOutliner sandboxed preferences area"
  copy_resource_between_local_directories "$source_path" "$destination_path" ; success_or_not

  report_adjust_setting "Set: General: For new documents: Use Template"
  defaults write ${domain} OUIResourceManagerUseDocumentTemplateForNewDocuments -bool true ; success_or_not

  report_adjust_setting "Set: path to custom template"
  defaults write ${domain} OUIResourceManagerDefaultDocumentTemplatePath -string "${destination_path}" ; success_or_not

  report_adjust_setting "Set: Keyboard: New rows are created: Always at the same level"
  defaults write ${domain} OOReturnShouldPossiblyIndent -bool false ; success_or_not

  report_end_phase_standard

}
