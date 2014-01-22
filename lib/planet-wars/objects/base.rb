class Base
  def initialize(planet)
    @tick = 0
    @ship = Ship.all.first
    @planet = planet
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
    @planet.diamond+=0.1
    @planet.gold+=0.4
    @planet.oil+=0.5
  end
end