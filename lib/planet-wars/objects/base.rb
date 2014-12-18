class Base < Chingu::BasicGameObject
  def initialize(planet, options={})
    super()
    @tick = 0
    @ship = Ship.all.first
    @planet = planet

    @x = options[:x]
    @y = options[:y]
  end

  def update
    if @tick >= 60
      harvest
      regenerate
      @tick = 0
    end
    @tick+=1
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

  def line(object, object2)
    # $window.fill_rect(object.x, object.x+2, object2.x, object2.y, color: Gosu::Color::RED) # check this
  end
end
