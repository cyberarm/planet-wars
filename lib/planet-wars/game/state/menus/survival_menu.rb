class SurvivalMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Mode//Survival"
    GameInfo::Mode.mode = "survival"
    super

    button "Easy", tooltip: "6 Enemies 2 Portals" do
      GameInfo::Config.number_of_enemies=6
      GameInfo::Config.number_of_portals=2
      push_game_state(Game)
    end

    button "Medium", tooltip: "12 Enemies 3 Portals" do
      GameInfo::Config.number_of_enemies=12
      GameInfo::Config.number_of_portals=3
      push_game_state(Game)
    end

    button "Hard", tooltip: "18 Enemies 5 Portals" do
      GameInfo::Config.number_of_enemies=18
      GameInfo::Config.number_of_portals=5
      push_game_state(Game)
    end

    button "Impossible", tooltip: "36 Enemies 10 Portals" do
      GameInfo::Config.number_of_enemies=36
      GameInfo::Config.number_of_portals=10
      push_game_state(Game)
    end

    button "Back" do
      push_game_state(MainMenu)
    end
  end
end