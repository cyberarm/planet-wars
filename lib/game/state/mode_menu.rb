class ModeMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Difficulty"
    super

    button "Easy", tooltip: "6 Enemies 2 Portals", color: Gosu::Color::GREEN do
      GameInfo::Config.number_of_enemies=6
      GameInfo::Config.number_of_portals=2
      push_game_state(Game)
    end

    button "Medium", tooltip: "12 Enemies 3 Portals", color: Gosu::Color::BLUE do
      GameInfo::Config.number_of_enemies=12
      GameInfo::Config.number_of_portals=3
      push_game_state(Game)
    end

    button "Hard", tooltip: "18 Enemies 5 Portals", color: Gosu::Color::RED do
      GameInfo::Config.number_of_enemies=18
      GameInfo::Config.number_of_portals=5
      push_game_state(Game)
    end

    button "Impossible", tooltip: "36 Enemies 10 Portals", color: Gosu::Color::BLACK do
      GameInfo::Config.number_of_enemies=36
      GameInfo::Config.number_of_portals=10
      push_game_state(Game)
    end

    button "Back" do
      push_game_state(MainMenu)
    end
  end
end