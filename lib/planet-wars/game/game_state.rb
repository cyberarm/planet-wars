class GameState
  attr_accessor :options
  attr_reader :game_objects

  def initialize(options={})
    @options = options
    @game_objects = []

    # setup
  end

  def setup
  end

  def draw
    # puts "Current GameState == #{self.class} => #{self == $window.current_game_state}"
    # puts "GO; #{@game_objects.count}"
    @game_objects.each(&:draw)
  end

  def update
    @game_objects.each(&:update)
  end

  def button_up(id)
    puts "b #{id}"
    @game_objects.each do |o|
      o.button_up(id)
    end
  end

  def push_game_state(klass, options={})
    $window.push_game_state(klass, options)
  end

  def fill_rect(x, y, width, height, color, z = 0)
    $window.draw_rect(x,y,width,height,color,z)
  end

  def add_game_object(object)
    @game_objects << object
  end
end
