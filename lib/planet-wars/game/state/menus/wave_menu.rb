class WaveMenu < GameUI
  def create
    set_title "#{GameInfo::NAME}//Mode//Wave"
    GameInfo::Mode.mode = "wave"

    button "1", tooltip: "1 waves" do
      # set number of waves
      GameInfo::Mode.waves=1
      GameInfo::Config.number_of_enemies=10
      GameInfo::Config.number_of_portals=3
      push_game_state(Game)
    end

    button "5", tooltip: "5 waves" do
      # set number of waves
      GameInfo::Mode.waves=5
      GameInfo::Config.number_of_enemies=10
      GameInfo::Config.number_of_portals=3
      push_game_state(Game)
    end

    button "10", tooltip: "10 waves" do
      # set number of waves
      GameInfo::Mode.waves=10
      GameInfo::Config.number_of_enemies=10
      GameInfo::Config.number_of_portals=3
      push_game_state(Game)
    end

    button "20", tooltip: "20 waves" do
      # set number of waves
      GameInfo::Mode.waves=20
      GameInfo::Config.number_of_enemies=10
      GameInfo::Config.number_of_portals=3
      push_game_state(Game)
    end

    button "Back" do
      go_back
    end
  end

  def go_back
    push_game_state(ModeMenu)
  end
end
