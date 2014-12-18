class MainMenu < GameUI
  trait :timer
  def initialize(options={})
    $music_manager.song.pause if defined?($music_manager) # Can not figure out why music starts playing here when it is paused...
    options[:title] = "#{GameInfo::NAME}"
    super

    button("Single Player", tooltip: "play the game") do
      push_game_state(ModeMenu)
    end

    button("Multiplayer", tooltip: "Play with an AI or a person") do
      push_game_state(MultiPlayerMenu)
    end

    button("Settings", tooltip: "Configure game") do
      push_game_state(SettingsMenu)
    end

    button("Credits", tooltip: "Find out who helped build this game") do
      push_game_state(Credits)
    end

    button("Exit", tooltip: "Quit game") do
      exit
    end
  end
end
