class WaveMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Wave"
    super

    button "5", tooltip: "5 waves" do
      # set number of waves
      #push_game_state(WaveMenu)
    end


    button "Back" do
      push_game_state(MainMenu)
    end
  end
end