class HealthBar < Chingu::GameObject
  def setup
    @ship  = Ship.all.first
    self.x = $window.width-(30*5)
    self.y = 30*12
    self.zorder = 999
    @tick  = 0
    @max_tick  = 10
  end

  def update
    self.factor = 10
    @image = update_image if @tick >= @max_tick
    @tick = 0 if @tick >= @max_tick
    @tick+=1
  end

  def update_image
    @h = 0
    @health = calc_health_percentage
    @tex_image = TexPlay.create_image($window,30,1)
    30.times do |i|
      @health.to_i.times do |h|
        if @health.to_i >= 20
          @tex_image.pixel(h,0, color: :green)
        elsif @health.to_i >= 10
          @tex_image.pixel(h,0, color: :yellow)
        elsif @health.to_i >= 0
          @tex_image.pixel(h,0, color: :red)
        end
        @h = h
      end
    end
    return @tex_image
  end

  def calc_health_percentage
    @ship.health / 3
  end
end