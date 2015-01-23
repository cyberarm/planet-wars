class BoostBar < Chingu::GameObject
  def setup
    @tick  = 0
    @ship  = Ship.all.first
    self.x = $window.width-(30*5)
    self.y = 30*11
    self.zorder = 999

    @color_boost = AssetManager.theme_color(AssetManager.theme_data['hud']['boost_bar'])
  end

  def update
    self.factor = 10
    @image = update_image
    @image = update_image if @tick >= 5
    @tick = 0 if @tick >= 5
    @tick+=1
  end

  def update_image
    calc_boost_percent
    @tex_image = TexPlay.create_image($window,30,1)
    calc_boost_percent.to_i.times do |i|
      @tex_image.pixel(i,0, color: @color_boost)
    end
    return @tex_image
  end

  def calc_boost_percent
    @ship.boost * 300.0 / 1000.0 * 30.0 / 100.0
  end
end
