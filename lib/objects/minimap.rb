class MiniMap < Chingu::GameObject
  def setup
    @tick = 0
    self.x = $window.width-(30*5)
    self.y = 30*5
    @ship = Ship.all.first
    # MiniMapGenerator.new([3000,3000], Planet.all, @ship)
  end

  def update
    self.factor = 10
    if @tick >= 10
      map = MiniMapGenerator.new([3000,3000], Planet.all, Ship.all.first)
      self.image = map.image#Gosu::Image.new($window, map)
      # self.image = Gosu::Image.new($window, "./lib/dev_stats/minimap.png")#.retrofy
      @tick = 0
    end
    @tick+=1
  end
end