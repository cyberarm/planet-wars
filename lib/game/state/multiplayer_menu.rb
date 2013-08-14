class MultiPlayerMenu < GameUI
  def initialize options={}
    options[:title] = "Multiplayer"
    super
    button "Join Game", tooltip: 'Join a game your friend is hosting' do
      # connect
      # play!
    end

    button "Host Game", tooltip: 'Host a game that your friends can join' do
      # start server
      # connect
      # play!
    end

    button "Back" do
      push_game_state(MainMenu)
    end
  end
end