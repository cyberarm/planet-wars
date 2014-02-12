class Background < Chingu::GameObject
  def setup
    @image = Gosu::Image["#{AssetManager.background_path}/background.png"]
    self.scale = 2.0
  end
end