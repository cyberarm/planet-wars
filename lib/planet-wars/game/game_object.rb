class GameObject
  INSTANCES = []
  Vertex = Struct.new(:x, :y)
  attr_accessor :image, :x, :y, :z, :angle, :center_x, :center_y, :scale_x, :scale_y,
                :color, :alpha, :mode, :options, :paused, :radius, :last_x, :last_y
  def initialize(options={})
    if options[:auto_manage] || options[:auto_manage] == nil
      INSTANCES.push(self)
      $window.current_game_state.add_game_object(self)
    end

    @options = options
    @image = options[:image] ? AssetManager.get_image(options[:image]) : nil
    @x = options[:x] ? options[:x] : 0
    @y = options[:y] ? options[:y] : 0
    @z = options[:z] ? options[:z] : 0
    @last_x = 0
    @last_y = 0
    @angle = options[:angle] ? options[:angle] : 0
    @center_x = options[:center_x] ? options[:center_x] : 0.5
    @center_y = options[:center_y] ? options[:center_y] : 0.5
    @scale_x  = options[:scale_x] ? options[:scale_x] : 1
    @scale_y  = options[:scale_y] ? options[:scale_y] : 1
    @color    = options[:color] ? options[:color] : Gosu::Color.argb(0xff_ffffff)
    @alpha    = options[:alpha] ? options[:alpha] : 255
    @mode = options[:mode] ? options[:mode] : :default
    @paused = false
    @speed = 0
    @debug_color = Gosu::Color::GREEN

    setup
    if @radius == 0 || @radius == nil
      @radius = options[:radius] ? options[:radius] : defined?(@image.width) ? ((@image.width+@image.height)/4)*scale : 1
    end
  end

  def draw
    if @image
      @image.draw_rot(@x, @y, @z, @angle, @center_x, @center_y, @scale_x, @scale_y, @color, @mode)
    end

    if $debug
      show_debug_heading
      $window.draw_circle(self.x, self.y, radius, 9999, @debug_color)
    end
  end

  def update
  end

  def scale
    if @scale_x == @scale_y
      return @scale_x
    else
      false
      # maths?
    end
  end

  def x=(i)
    @last_x = @x
    @x = i
  end

  def y=(i)
    @last_y = @y
    @y = i
  end

  def heading(ahead_by = 100, object = nil)
    direction = ((Gosu.angle(@last_x, @last_y, self.x, self.y)) - 90.0) * (Math::PI / 180.0)
    ahead_by+object.speed*Engine.dt if object
    _x = @x+(ahead_by*Math.cos(direction))
    _y = @y+(ahead_by*Math.sin(direction))
    Vertex.new(_x, _y)
  end

  def show_debug_heading
    _heading = heading
    $window.draw_line(x, y, @debug_color, _heading.x, _heading.y, @debug_color, 9999)
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

  def scale=(int)
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

  def circle_collision?(object)
    distance = Gosu.distance(self.x, self.y, object.x, object.y)
    if distance <= self.radius+object.radius
      true
    else
      false
    end
  end

  # Duplication... so DRY.
  def each_circle_collision(object, resolve_with = :width, &block)
    if object.class != Class && object.instance_of?(object.class)
      $window.current_game_state.game_objects.select {|i| i.class == object.class}.each do |o|
        distance = Gosu.distance(self.x, self.y, object.x, object.y)
        if distance <= self.radius+object.radius
          block.call(o, object) if block
        end
      end
    else
      list = $window.current_game_state.game_objects.select {|i| i.class == object}
      list.each do |o|
        next if self == o
        distance = Gosu.distance(self.x, self.y, o.x, o.y)
        if distance <= self.radius+o.radius
          block.call(self, o) if block
        end
      end
    end
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
    INSTANCES.select {|i| i.class == self}
  end

  def self.each_circle_collision(object, resolve_with = :width, &block)
    if object.class != Class && object.instance_of?(object.class)
      $window.current_game_state.game_objects.select {|i| i.class == self}.each do |o|
        distance = Gosu.distance(o.x, o.y, object.x, object.y)
        if distance <= o.radius+object.radius
          block.call(o, object) if block
        end
      end
    else
      lista = $window.current_game_state.game_objects.select {|i| i.class == self}
      listb = $window.current_game_state.game_objects.select {|i| i.class == object}
      lista.product(listb).each do |o, o2|
        next if o == o2
        distance = Gosu.distance(o.x, o.y, o2.x, o2.y)
        if distance <= o.radius+o2.radius
          block.call(o, o2) if block
        end
      end
    end
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
