class ModeMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//GameMode"
    super

    button "Survival", tooltip: "Survive for as long as you can.", color: Gosu::Color::RED do
      push_game_state(SurvivalMenu)
    end

    button "Wave", tooltip: "Complete all waves of increasing difficulty", color: Gosu::Color::BLUE do
      push_game_state(WaveMenu)
    end

    button "Back" do
      push_game_state(MainMenu)
    end
  end
end