class Base
  def initialize(planet)
    @tick = 0
    @ship = Ship.all.first
    @planet = planet
  end

  def update
    if @tick >= 60
      @ship.diamond+=1 unless @planet.diamond <= 0
      @ship.gold+=10 unless @planet.gold <= 0
      @ship.oil+=10 unless @planet.oil <= 0

      @planet.diamond-=1 unless @planet.diamond <= 0
      @planet.gold-=10 unless @planet.gold <= 0
      @planet.oil-=10 unless @planet.oil <= 0

      @tick = 0
    end
    @tick+=1
  end
end