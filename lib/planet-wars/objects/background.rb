class Background < GameObject
  def setup
    @image = AssetManager.get_image("#{AssetManager.background_path}/background.png")
    self.scale_x = 2.0
    self.scale_y = 2.0
  end
end
