class MultiPlayerMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Multiplayer"
    super
    button "Online Multiplayer", tooltip: 'play the game with friends (Unavailable)' do
      puts "Functional Multiplayer is Not Available with this build."
      # push_game_state(OnlineMultiPlayerMenu)
      # push_game_state(NetGame)
    end

    button "Deathmatch", tooltip: 'Play against an AI ship (Unavailable)' do
    end

    button "Cooperative", tooltip: 'Play with an AI ship against enemy ships (Unavailable)' do
    end

    button "Back" do
      push_game_state(MainMenu)
    end
  end
end
