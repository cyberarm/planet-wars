class TargetArea < GameObject
  attr_reader :in_range, :radius

  def setup
    @owner     = @options[:owner]
    @target    = @options[:target]
    @size      = @options[:size]
    @in_range  = false
    @radius    = 1000
  end

  def update
    @debug_color = Gosu::Color.rgb(rand(150..200),rand(150..200),rand(150..200)) if $debug

    self.x = @owner.x
    self.y = @owner.y

    if self.circle_collision?(@target)
      @in_range = true
    else
      @in_range = false
    end
  end
end
