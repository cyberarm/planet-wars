class NetGame < Chingu::GameState
  def setup
    @server = NetServer.connect("192.168.1.101", 67518)
  end

  def update
  end
end