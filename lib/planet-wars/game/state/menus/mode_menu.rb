class ModeMenu < GameUI
  def create
    set_title("#{GameInfo::NAME}//Mode")

    button "Survival", tooltip: "Survive for as long as you can." do
      push_game_state(SurvivalMenu)
    end

    button "Wave", tooltip: "Complete all waves of increasing difficulty" do
      push_game_state(WaveMenu)
    end

    button "Back" do
      go_back
    end
  end

  def go_back
    push_game_state(MainMenu)
  end
end
