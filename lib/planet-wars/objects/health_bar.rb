class HealthBar < Chingu::GameObject
  include Chingu::Helpers::GFX

  def setup
    @ship  = Ship.all.first
    self.x = $window.width-(300)
    self.y = 31*12
    self.zorder = 999
    @tick  = 0
    @max_tick  = 10

    @color_full = AssetManager.theme_color(AssetManager.theme_data['hud']['health_bar']['full'])
    @color_half = AssetManager.theme_color(AssetManager.theme_data['hud']['health_bar']['half'])
    @color_low  = AssetManager.theme_color(AssetManager.theme_data['hud']['health_bar']['low'])
  end

  def draw
    @health = calc_health_percentage
    @health.to_i.times do |h|
      if @health.to_i >= 65
        fill_rect([x, y, @health*3, 30], @color_full, 999)
      elsif @health.to_i >= 45
        fill_rect([x, y, @health*3, 30], @color_half, 999)
      elsif @health.to_i >= 25
        fill_rect([x, y, @health*3, 30], @color_low, 999)
      end
    end
  end

  def calc_health_percentage
    (@ship.health/@ship.max_health.to_f)*100.0
  end
end
