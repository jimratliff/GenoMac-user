#!/usr/bin/env zsh

# NOTE: This replaces the now-deprecated (11/11/2026) `defaults write` approach.

function set_chatgpt_settings() {
  # Implement settings for ChatGPT via a $GMU_CHATGPT_TOML
  #
  # The settings themselves are assumed to be set in $GMU_CHATGPT_TOML
  # HINT:
  # - GMU_CHATGPT_TOML="${GMU_RESOURCES}/chatgpt_toml/chatgpt-desired.toml"
  # - GMU_PYTHON="${GENOMAC_USER_LOCAL_DIRECTORY}/python"

  report_start_phase_standard

  local path_to_python_script="${GMU_PYTHON}/apply-chatgpt-config.py"
  local path_to_toml_declaration="${GMU_CHATGPT_TOML}"
  local path_to_ChatGPT_config_toml="$CODEX_CONFIG_DIRECTORY/config.toml"

	python3 "${path_to_python_script}" \
	  "$path_to_toml_declaration" \
	  "$path_to_ChatGPT_config_toml"

	disable_chatgpt_pet_shortcut

  report_end_phase_standard
}

function disable_chatgpt_pet_shortcut() {
	# Disables ChatGPT’s most-annoying default: Specifying a global shortcut to show/hide the “pet.”
	# ChatGPT stores this shortcut at ~/.codex/keybindings.json
	# under "command": "openAvatarOverlay"
	#
	report_start_phase_standard

  node - "$HOME/.codex/keybindings.json" <<'JS'
const fs = require('node:fs');
const path = require('node:path');

const file = process.argv[2];
const command = 'openAvatarOverlay';
let bindings = [];

try {
  bindings = JSON.parse(fs.readFileSync(file, 'utf8'));
} catch (error) {
  if (error.code !== 'ENOENT') throw error;
}

if (!Array.isArray(bindings)) {
  throw new Error(`Expected a JSON array in ${file}`);
}

const matching = bindings.filter(binding => binding?.command === command);
if (matching.length === 1 && matching[0].key === null) {
  process.exit(0);
}

const updated = bindings.filter(binding => binding?.command !== command);
updated.push({ command, key: null });

const directory = path.dirname(file);
fs.mkdirSync(directory, { recursive: true });
const scratch = fs.mkdtempSync(path.join(directory, '.keybindings-'));
const temporary = path.join(scratch, 'keybindings.json');

try {
  fs.writeFileSync(temporary, JSON.stringify(updated, null, 2) + '\n', {
    mode: 0o600,
  });
  fs.renameSync(temporary, file);
} finally {
  fs.rmSync(scratch, { recursive: true, force: true });
}
JS

	report_end_phase_standard
}
