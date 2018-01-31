class BoostBar < GameObject
  def setup
    @tick  = 0
    @ship  = Ship.all.first
    self.x = $window.width-(300)
    self.y = 30*11
    self.z = 999

    @color_boost = AssetManager.theme_color(AssetManager.theme_data['hud']['boost_bar'])
  end

  def draw
    fill_rect(x,y, calc_boost_percent*3, 30, @color_boost, 999)
  end

  def calc_boost_percent
    (@ship.boost/@ship.max_boost.to_f)*100.0
  end
end
