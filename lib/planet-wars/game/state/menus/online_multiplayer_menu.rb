class OnlineMultiPlayerMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Multiplayer//Online"
    super
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
      push_game_state(previous_game_state)
    end
  end
end
