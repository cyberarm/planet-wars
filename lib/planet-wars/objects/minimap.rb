class MiniMap < GameObject
  def setup
    @tick = 0
    self.x = $window.width-(30*5)
    self.y = 30*5
    self.z = 999
    @ship = Ship.all.first
    @map = MiniMapGenerator.new(options[:viewport_area], Planet.all, Enemy.all, Asteroid.all, Ship.all)
  end

  def draw
    @map.draw
  end
end
