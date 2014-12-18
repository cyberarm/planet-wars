class ModeMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Mode"
    super

    button "Survival", tooltip: "Survive for as long as you can." do
      push_game_state(SurvivalMenu)
    end

    button "Wave", tooltip: "Complete all waves of increasing difficulty" do
      push_game_state(WaveMenu)
    end

    button "Back" do
      push_game_state(MainMenu)
    end
  end
end
