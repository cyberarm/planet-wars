class MainMenu < GameUI
  trait :timer
  def initialize(options={})
    $music_manager.song.pause if defined?($music_manager) # Can not figure out why music starts playing here when it is paused...
    options[:title] = "Planet Wars"
    super

    button("Single Player", tooltip: "play the game") do
      push_game_state(ModeMenu)
    end

    button("Multiplayer", tooltip: "play the game with friends (Unavailable)") do
      push_game_state(MultiPlayerMenu)
      puts "Functional Multiplayer is Not Available with this build."
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