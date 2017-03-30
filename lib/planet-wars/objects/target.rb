class Target < Chingu::GameObject
  trait :bounding_box
  trait :collision_detection
  def setup
    @image = Gosu::Image.from_text("O", 10)
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
