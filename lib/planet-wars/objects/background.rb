class Background < Chingu::GameObject
  def setup
    @image = Gosu::Image["assets/backgrounds/background-04.png"]
    self.scale = 2.0
  end
end