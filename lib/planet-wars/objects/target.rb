class Target < Chingu::GameObject
  trait :bounding_box
  trait :collision_detection
  def setup
    @image = TexPlay.create_image($window,10,10)
    @target= @options[:target]
    @tick  = 0
    self.x = @target.x
    self.y = @target.y
  end

  def update
      mover
  end

  def mover
    self.x = @target.x
    self.y = @target.y
  end
end
