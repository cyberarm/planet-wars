class MainMenu < GameUI
  trait :timer
  def initialize(options={})
    options[:title] = "Planet Wars" # Set menu header
    super

    button("Single Player", tooltip: "play the game") do
      push_game_state(Game)
    end

    button("Multiplayer", tooltip: "play the game with friends") do
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