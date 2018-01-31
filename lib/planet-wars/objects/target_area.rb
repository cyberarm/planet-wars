class TargetArea < GameObject
  attr_reader :in_range, :radius

  def setup
    @debug_color = Gosu::Color.rgb(100,200,100)

    @owner     = @options[:owner]
    @target    = @options[:target]
    @size      = @options[:size]
    @in_range  = false
  end

  def update
    self.radius = 1000
    self.x = @owner.x
    self.y = @owner.y

    if self.circle_collision?(@target)
      @in_range = true
    else
      @in_range = false
    end
  end
end
