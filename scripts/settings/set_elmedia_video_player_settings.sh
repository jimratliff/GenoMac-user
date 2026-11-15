#!/usr/bin/env zsh

function set_elmedia_video_player_settings() {

  report_start_phase_standard
  report_action_taken "Implement Elmedia Video Player settings"

  local domain="$DEFAULTS_DOMAINS_ELMEDIA_PLAYER_MAS"
  # HINT: DEFAULTS_DOMAINS_ELMEDIA_PLAYER_MAS="com.Eltima.ElmediaPlayer.MAS"

  report_adjust_setting "Playlist 1 of 3: Don’t add autoplay files to playlist"
  defaults write ${domain} isAutoplayOptionEnabled -bool false ; success_or_not

  report_adjust_setting "Playlist 2 of 3: Don’t automatically add files to playlist on opening"
  defaults write ${domain} AddOpenFilesToPlaylist -bool false ; success_or_not

  report_adjust_setting "Playlist 3 of 3: Do clear playlist when quitting"
  defaults write ${domain} ClearPlaylistOnQuit -bool true ; success_or_not

  report_adjust_setting "Toggle play/pause on single click"
  defaults write ${domain} SingleClickAction -integer 1 ; success_or_not

	set_elmedia_video_player_hotkeys

	report_end_phase_standard
}


function set_elmedia_video_player_hotkeys() {
  # Sets hotkeys for Elmedia Video Player all at once, replacing whatever might have been there,
  # as opposed to selectively changing hotkeys.
  #
  # Installs keyBindings specified in
  #
  # To get these keyBinders:
  #   defaults export "$domain" - | plutil -extract keyBindings xml1 -o ~/Documents/keyBindings.plist -
  report_start_phase_standard

  local bindings
  local bindings_file="$ELMEDIA_KEYBINDINGS"

  local domain="$DEFAULTS_DOMAINS_ELMEDIA_PLAYER_MAS"
  # HINT: DEFAULTS_DOMAINS_ELMEDIA_PLAYER_MAS="com.Eltima.ElmediaPlayer.MAS"

  report_action_taken "Assign full set of hotkeys for Elmedia Video Player."

  bindings=$(<"$bindings_file")
  defaults write "$domain" keyBindings "$bindings"

  report_end_phase_standard
}
