class TargetArea < Chingu::GameObject
  trait :bounding_circle
  trait :collision_detection

  attr_reader :in_range

  def setup
    @owner     = @options[:owner]
    @target    = @options[:target]
    @size      = @options[:size]
    @in_range  = false
    @image     = TexPlay.create_image($window, 10, 10, color: Gosu::Color.argb(0,0,0,0))
    self.scale = @size if @size
    self.scale = 100.0 unless @size
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