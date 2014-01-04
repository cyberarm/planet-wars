class GameHUD
  def initialize
    @minimap      = MiniMap.new
    @boost_bar    = BoostBar.new
    @health_bar   = HealthBar.new
  end

  def draw
    @boost_bar.draw
    @health_bar.draw
    @minimap.draw
  end

  def update
    @minimap.update
    @health_bar.update
    @boost_bar.update
  end
end