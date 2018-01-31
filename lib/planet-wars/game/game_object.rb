class GameObject
  INSTANCES = []
  attr_accessor :image, :x, :y, :z, :angle, :center_x, :center_y, :scale_x, :scale_y, :color, :alpha, :mode, :options, :paused
  def initialize(options={})
    INSTANCES.push(self)
    $window.current_game_state.add_game_object(self)

    @options = options
    @image = options[:image] ? AssetManager.get_image(options[:image]) : nil
    @x = options[:x] ? options[:x] : 0
    @y = options[:y] ? options[:y] : 0
    @z = options[:z] ? options[:z] : 0
    @angle = options[:angle] ? options[:angle] : 0
    @center_x = options[:center_x] ? options[:center_x] : 0.5
    @center_y = options[:center_y] ? options[:center_y] : 0.5
    @scale_x  = options[:scale_x] ? options[:scale_x] : 1
    @scale_y  = options[:scale_y] ? options[:scale_y] : 1
    @color    = options[:color] ? options[:color] : Gosu::Color.argb(0xff_ffffff)
    @alpha    = options[:alpha] ? options[:alpha] : 255
    @mode = options[:mode] ? options[:mode] : :default
    @paused = false

    setup
  end

  def draw
    if @image
      @image.draw_rot(@x, @y, @z, @angle, @center_x, @center_y, @scale_x, @scale_y, @color, @mode)
    end
  end

  def update
    if @paused
      update
    end
  end

  def width
    @image ? @image.width : 0
  end

  def height
    @image ? @image.height : 0
  end

  def pause
    @paused = true
  end

  def unpause
    @paused = false
  end

  def scale(int)
    self.scale_x = int
    self.scale_y = int
  end

  def rotate(int)
    self.angle+=int
    self.angle%=360
  end

  def alpha=int # 0-255
    @alpha = int
    @color = Gosu::Color.rgba(@color.red, @color.green, @color.blue, int)
  end

  def fill_rect(x, y, width, height, color, z = 0)
    $window.draw_rect(x,y,width,height,color,z)
  end

  def button_up(id)
  end

  def button_down?(id)
  end

  def destroy
    INSTANCES.delete(self)
    if $window.current_game_state
      $window.current_game_state.game_objects.each do |o|
        if o.is_a?(self.class) && o == self
          $window.current_game_state.game_objects.delete(o)
        end
      end
    end
  end

  # NOTE: This could be implemented more reliably
  def self.all
    t_array = []
    INSTANCES.each do |o|
      # NOTE: This is odd...
      if o.class == self
        t_array << o
      end
    end
    t_array
  end

  def self.each_circle_collision(object)
    
  end

  def self.destroy_all
    INSTANCES.clear
    if $window.current_game_state
      $window.current_game_state.game_objects.each do |o|
        if o.is_a?(self.class)
          $window.current_game_state.game_objects.delete(o)
        end
      end
    end
  end
end
