class Base < GameObject
  attr_accessor :x, :y
  def setup
    @last_harvest = Engine.now
    @ship = @options[:ship]
    @planet = @options[:planet]
    @cannon_range      = 250 # screen pixels
    @cannon_last_fired = Engine.now
    @cannon_last_shown = Engine.now
    @cannon_color      = Gosu::Color.rgb(rand(150..255), rand(150..255), rand(150..255))
    @target            = nil
    @radius = 250

    @x = @options[:x]
    @y = @options[:y]
    @z = 9999
  end

  def update
    if (Engine.now-@last_harvest) >= 1000.0
      harvest
      regenerate
      @last_harvest = Engine.now
    end

    fire_cannon if Engine.now-@cannon_last_fired >= 500.0
  end

  def draw
    super
    $window.draw_line(self.x, self.y, @debug_color, @target.x, @target.y, @color, 9999) if @target && $debug
    line(@target) if @target && Engine.now-@cannon_last_shown <= 250.0
  end

  def harvest
    diamond = 60*Engine.dt
    gold    = 600*Engine.dt
    oil     = 600*Engine.dt

    if @planet.diamond >= diamond
      @ship.diamond+=diamond unless @planet.diamond <= 0
      @planet.diamond-=diamond unless @planet.diamond <= 0
    else
      @ship.diamond+=@planet.diamond unless @planet.diamond <= 0
      @planet.diamond-=@planet.diamond unless @planet.diamond <= 0
    end

    if @planet.gold >= gold
      @ship.gold+=gold unless @planet.gold <= 0
      @planet.gold-=gold unless @planet.gold <= 0
    else
      @ship.gold+=@planet.gold unless @planet.gold <= 0
      @planet.gold-=@planet.gold unless @planet.gold <= 0
    end

    if @planet.oil >= oil
      @ship.oil+=oil unless @planet.oil<= 0
      @planet.oil-=oil unless @planet.oil<= 0
    else
      @ship.oil+=@planet.oil unless @planet.oil <= 0
      @planet.oil-=@planet.oil unless @planet.oil <= 0
    end
  end

  def regenerate
    @planet.diamond+=(rand(0.1..0.3)*60)*Engine.dt
    @planet.gold+=(rand(0.4..1.0)*60)*Engine.dt
    @planet.oil+=(rand(0.5..2.0)*60)*Engine.dt
  end

  def fire_cannon
    # Get targetable objects
    # prefer Enemy to Asteroid
    @cannon_last_fired = Engine.now
    Enemy.all.detect.each do |e|
      if Gosu.distance(self.x, self.y, e.x, e.y) <= @cannon_range
        @target = e
        @cannon_last_shown = Engine.now
        @target.hit(5, self)
        return true
      end
    end

    unless @target
      Asteroid.all.detect.each do |e|
        if Gosu.distance(self.x, self.y, e.x, e.y) <= @cannon_range
          @target = e
          @cannon_last_shown = Engine.now
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

    width.times do |i|
      $window.draw_line(x+i,y+i,color,x2+i,y2+i,color,z)
    end
    # return $window.draw_rect(x, y, x2+width, y2+width, color, z)
  end
end
