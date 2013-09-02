class WorldGen
  def initialize(number_of_planets, width, height)
    number_of_planets.times do
      planet = Planet.create(x: rand(100..width-100), y: rand(100..height-100), zorder: 0)
    end
  end
end