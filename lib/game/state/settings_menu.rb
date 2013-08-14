class SettingsMenu < GameUI
  def initialize options={}
    options[:title] = 'Settings'
    super

    button("Back"){push_game_state(MainMenu)}
  end
end