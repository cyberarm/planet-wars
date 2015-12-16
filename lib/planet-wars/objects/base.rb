class Base < Chingu::BasicGameObject
  attr_accessor :x, :y
  def setup
    @tick = 0
    @ship = @options[:ship]
    @planet = @options[:planet]
    @cannon_range      = 250 # screen pixels
    @cannon_tick       = 0
    @show_cannon_tick  = 0
    @cannon_color      = Gosu::Color.rgb(rand(25..255), rand(25..255), rand(25..255))
    @target            = nil

    @x = @options[:x]
    @y = @options[:y]
  end

  def update
    if @tick >= 60
      harvest
      regenerate
      @tick = 0
    end

    fire_cannon if @cannon_tick >= 30

    @tick+=1
    @cannon_tick+=1
    @show_cannon_tick+=1
  end

  def draw
    line(@target) if @target && @show_cannon_tick <= 15
  end

  def harvest
    if @planet.diamond >= 1.0
      @ship.diamond+=1 unless @planet.diamond <= 0
      @planet.diamond-=1 unless @planet.diamond <= 0
    else
      @ship.diamond+=@planet.diamond unless @planet.diamond <= 0
      @planet.diamond-=@planet.diamond unless @planet.diamond <= 0
    end

    if @planet.gold >= 10.0
      @ship.gold+=10 unless @planet.gold <= 0
      @planet.gold-=10 unless @planet.gold <= 0
    else
      @ship.gold+=@planet.gold unless @planet.gold <= 0
      @planet.gold-=@planet.gold unless @planet.gold <= 0
    end

    if @planet.oil >= 10.0
      @ship.oil+=10 unless @planet.oil<= 0
      @planet.oil-=10 unless @planet.oil<= 0
    else
      @ship.oil+=@planet.oil unless @planet.oil <= 0
      @planet.oil-=@planet.oil unless @planet.oil <= 0
    end
  end

  def regenerate
    @planet.diamond+=rand(0.1..0.3)
    @planet.gold+=rand(0.4..1.0)
    @planet.oil+=rand(0.5..2.0)
  end

  def fire_cannon
    # Get targetable objects
    # prefer Enemy to Asteroid
    @cannon_tick = 0
    Enemy.all.detect.each do |e|
      if Gosu.distance(self.x, self.y, e.x, e.y) <= @cannon_range
        @target = e
        @show_cannon_tick = 0
        @target.hit(5, self)
        return true
      end
    end

    unless @target
      Asteroid.all.detect.each do |e|
        if Gosu.distance(self.x, self.y, e.x, e.y) <= @cannon_range
          @target = e
          @show_cannon_tick = 0
          @target.hit(15, self)
          return true
        end
      end
    end

    if @target && Gosu.distance(self.x, self.y, @target.x, @target.y) > @cannon_range
      @target = nil
    end
  end

  def line(obj_b, width = 4, color = @cannon_color, z = Float::INFINITY)
    obj_a = self
    x, y = obj_a.x, obj_a.y
    x2, y2 = obj_b.x, obj_b.y

    return $window.draw_quad(x, y, color,
                             x+width, y-width, color,
                             x2, y2, color,
                             x2+width, y2+width, color,
                             z)
  end
end
