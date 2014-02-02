class MiniMap < Chingu::GameObject
  def setup
    @tick = 0
    self.x = $window.width-(30*5)
    self.y = 30*5
    self.zorder = 999
    @ship = Ship.all.first
  end

  def update
    self.factor = 10
    if @tick >= 10
      map = MiniMapGenerator.new([3000,3000], Planet.all, Enemy.all, Asteroid.all, Ship.all.first)
      self.image = map.image.retrofy
      @tick = 0
    end
    @tick+=1
  end
end