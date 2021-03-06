class Target < GameObject
  def setup
    @target= @options[:target]
    @tick  = 0
    self.x = @target.x
    self.y = @target.y
    @radius=10
  end

  def update
      mover
  end

  def mover
    self.x = @target.x
    self.y = @target.y
  end

  def speed
    if defined?(@target.active_speed)
      @target.active_speed
    else
      @target.speed
    end
  end
end
