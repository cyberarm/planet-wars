class MiniMapGenerator
  attr_reader :image
  def initialize(area, planets, enemies, asteroid, ship)
    #area = [play area width, play area height]
    #objects = [Planets, Stars]
    @area    = area
    @planets = planets
    @enemies = enemies
    @asteroids=asteroid
    @ship    = ship
    @image   = TexPlay.create_image($window, area[0]/100, area[1]/100)#, caching: false)
    generate_image
    return @image
  end

  def generate_image
    @planets.each do |planet|
      if planet.habitable
        @image.pixel(planet.x/100, planet.y/100, color: :blue) if planet.base.nil?
        @image.pixel(planet.x/100, planet.y/100, color: :cyan) unless planet.base.nil?
      else
        @image.pixel(planet.x/100, planet.y/100, color: :yellow)
      end
    end

    @enemies.each do |enemy|
      @image.pixel(enemy.x/100, enemy.y/100, color: :red)
    end

    @asteroids.each do |asteroid|
      @image.pixel(asteroid.x/100, asteroid.y/100, color: :black)
    end

    @image.pixel(@ship.x/100, @ship.y/100, color: :green)
  end
end