class GameState
  SCALE_X_BASE = 1920.0
  SCALE_Y_BASE = 1080.0
  attr_accessor :options, :global_pause
  attr_reader :game_objects

  def initialize(options={})
    $window.set_game_state(self)
    @options = options unless @options
    @game_objects = []
    @global_pause = false

    setup
    @_4ship = Ship.all.first if Ship.all.is_a?(Array)
  end

  def setup
  end

  def draw
    # count = 0
    @game_objects.each do |o|
      o.draw if o.visible
      # p o.class if o.visible
      # count+=1 if o.visible
    end
    # puts "Num visible objects: #{count} of #{@game_objects.count}"
  end

  def update
    @game_objects.each do |o|
      unless o.paused || @global_pause
        o.world_center_point.x = @_4ship.x
        o.world_center_point.y = @_4ship.y

        o.update
      end
    end
  end

  def destroy
    @options = nil
    @game_objects = nil
  end

  def button_up(id)
    @game_objects.each do |o|
      o.button_up(id) unless o.paused
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
