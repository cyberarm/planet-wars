class Target < Chingu::GameObject
  trait :bounding_circle
  trait :collision_detection
  def setup
    @image = TexPlay.create_image($window,10,10)
    @tick = 0
  end

  def update
    @tick+=1
    if @tick >= 10
      @tick = 0
      self.x,self.y = Ship.all.first.x,Ship.all.first.y
    end
  end
end