class WorldGen
  attr_reader :number_of_planets, :width, :height

  def initialize(number_of_planets, number_of_portals, width, height)
    @width = width
    @height = height
    GameInfo::Config.game_time=Time.now
    @planet_row = 0
    @planet_column = 0
    @planet_size = 400

    number_of_planets.times do |i|
      planet_x
      Planet.new(x: planet_x, y: planet_y, z: 0)
    end

    number_of_portals.times do
      Portal.new(world_width: @width, world_height: @height, x: rand(100..width-100), y: rand(100..height-100), z: 199)
    end
  end

  def planet_x
    if (@planet_column*@planet_size)-100 >= width
      @planet_column=0
      @planet_row+=1
    end
    @planet_column+=1
    raise "No more room for planets" if (@planet_row*@planet_size)-100 >= height
    return @planet_column*@planet_size
  end

  def planet_y
    return @planet_row*@planet_size
  end
end
