class ModeMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Difficulty"
    super

    button "Easy", color: Gosu::Color::GREEN, hover_color: Gosu::Color.argb(100, 0,255,0) do
      GameInfo::Config.number_of_enemies=6
      GameInfo::Config.number_of_portals=2
      push_game_state(Game)
    end

    button "Medium", color: Gosu::Color::BLUE, hover_color: Gosu::Color.argb(100, 0,0,255) do
      GameInfo::Config.number_of_enemies=12
      GameInfo::Config.number_of_portals=3
      push_game_state(Game)
    end

    button "Hard", color: Gosu::Color::RED, hover_color: Gosu::Color.argb(100, 255,0,0) do
      GameInfo::Config.number_of_enemies=18
      GameInfo::Config.number_of_portals=5
      push_game_state(Game)
    end

    button "Impossible", color: Gosu::Color.argb(100, 225,225,225), hover_color: Gosu::Color.argb(25, 225,225,225) do
      GameInfo::Config.number_of_enemies=36
      GameInfo::Config.number_of_portals=10
      push_game_state(Game)
    end

    button "Back" do
      push_game_state(MainMenu)
    end
  end
end