class SettingsMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Settings"
    super

    button("Music", tooltip: "Play/Stop music"){$music_manager.toggle} if defined?($music_manager)
    button("Sound", tooltip: "Enable/Disable sound effects (Unavailable)"){}
    button("Back"){push_game_state(MainMenu)}
  end
end