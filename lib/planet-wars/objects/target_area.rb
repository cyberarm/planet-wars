class TargetArea < Chingu::GameObject
  trait :collision_detection

  attr_reader :in_range, :radius

  def setup
    @owner     = @options[:owner]
    @target    = @options[:target]
    @size      = @options[:size]
    @in_range  = false
    @radius    = 1000
  end

  def update
    self.x = @owner.x
    self.y = @owner.y

    if self.collision?(@target)
      @in_range = true
    else
      @in_range = false
    end
  end
end
