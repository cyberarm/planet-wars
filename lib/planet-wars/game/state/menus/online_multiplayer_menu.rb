class OnlineMultiPlayerMenu < GameUI
  def create
    set_title "#{GameInfo::NAME}//Multiplayer//Online"

    button "Join Game", tooltip: 'Join a game your friend is hosting (Unavailable)' do
      # connect
      # play!
    end

    button "Host Game", tooltip: 'Host a game that your friends can join (Unavailable)' do
      # start server
      # connect
      # play!
      # push_game_state(NetGame.new(host: true, client: false))
    end

    button "Back" do
      go_back
    end
  end

  def go_back
    push_game_state(MultiPlayerMenu)
  end
end
