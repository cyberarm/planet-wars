class WorldGen
  attr_reader :number_of_planets, :width, :height

  def initialize(number_of_planets, number_of_portals, width, height)
    @width = width
    @height = height
    GameInfo::Config.game_time=Time.now

    number_of_planets.times do
      Planet.new(x: rand(100..width-100), y: rand(100..height-100), z: 0)
    end

    number_of_portals.times do
      Portal.new(world_width: @width, world_height: @height, x: rand(100..width-100), y: rand(100..height-100), z: 199)
    end
  end
end