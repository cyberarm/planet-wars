class WorldGen
  attr_reader :number_of_planets, :width, :height

  def initialize(number_of_planets, number_of_portals, width, height)
    @width = width
    @height = height
    GameInfo::Config.game_time=Time.now
    @planet_row = 0
    @planet_column = 0
    @planet_size = 400

    generate_grid

    number_of_planets.times do |i|
      grid_add(Planet)
    end

    # pp @grid

    number_of_portals.times do
      Portal.new(world_width: @width, world_height: @height, x: rand(100..width-100), y: rand(100..height-100), z: 199)
    end
  end

  def generate_grid(chunk_size = 800)
    @grid = []
    @grid_chunk_size = chunk_size
    @grid_width = @width/chunk_size
    @grid_height = @height/chunk_size
    @grid_height.times do
      row = []
      @grid_width.times do
        row << nil
      end
      @grid << row
    end
  end

  def grid_add(object)
    placed = false
    @grid.each_with_index do |d, x|
      break if placed
      d.each_with_index do |t, y|
        break if placed
        if @grid[y][x] == nil
          @grid[y][x] = true
          object = object.new(z: 0)
          object.x = (x*@grid_chunk_size)+@grid_chunk_size
          object.y = (y*@grid_chunk_size)+@grid_chunk_size/2
          placed = true
          break
        end
      end
    end
    puts "Skipped #{object}! no room!" if !placed && $debug
  end
end
