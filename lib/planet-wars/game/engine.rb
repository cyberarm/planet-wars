class Engine < Gosu::Window
  attr_accessor :show_cursor
  attr_reader :current_game_state, :last_game_state, :last_frame_time

  def self.now
    Gosu.milliseconds
  end

  def self.dt
    $window.last_frame_time/1000.0
  end

  def initialize(width = 800, height = 600, fullscreen = false, update_interval = 1000.0/60)
    if File.exists?("fps_log.log")
      File.open("fps_log.log") do |file|
        list = []
        file.each do |line|
          next if line.strip == ""
          list << Float(line.strip)
        end
        puts "Last session FPS: MIN #{list.min} AVG #{list.reduce(:+).to_f / list.size} MAX #{list.max}"
      end
    end
    @fps_log     = File.open("fps_log.log", 'w')
    @show_cursor = false
    width = Gosu.screen_width if ConfigManager.config["screen"]["width"] == 'max'
    width = ConfigManager.config["screen"]["width"] if ConfigManager.config["screen"]["width"].is_a?(Integer)

    height= Gosu.screen_height if ConfigManager.config["screen"]["height"] == 'max'
    height= ConfigManager.config["screen"]["height"] if ConfigManager.config["screen"]["height"].is_a?(Integer)

    if ARGV.join.include?("--low")
      update_interval = 1000.0/30
    end

    super(width, height, ConfigManager.config["screen"]["fullscreen"], update_interval)
    $window = self
    @last_frame_time = Gosu.milliseconds-1
    @current_frame_time = Gosu.milliseconds
    self.caption = "#{GameInfo::NAME} #{GameInfo::VERSION} (#{GameInfo::RELEASE_NAME}) [build: #{BUILD}] #{Gosu.language}"
    AssetManager.preload_assets if ARGV.join.include?('--debug')

    Logger.log("Window: width: #{width}, height: #{height}, fullscreen: #{fullscreen}, update_interval: #{update_interval}", self)

    if ARGV.join.include?('--net')
      push_game_state(NetGame)
    elsif ARGV.join.include?('--debug_game')
      push_game_state(Game)
    elsif ARGV.join.include?('--quick')
      AssetManager.preload_assets
      push_game_state(MainMenu)
    else
      push_game_state(Boot)
    end

    at_exit do
      @fps_log.close
    end
  end

  def draw
    if @current_game_state.is_a?(GameState)
      @current_game_state.draw
    end
  end

  def update
    if @current_game_state.is_a?(GameState)
      @current_game_state.update
    end
    @fps_log.write("#{Gosu.fps}\n")
    @last_frame_time = Gosu.milliseconds-@current_frame_time
    @current_frame_time = Gosu.milliseconds
  end

  def needs_cursor?
    @show_cursor
  end

  def dt
    @last_frame_time/1000.0
  end

  def button_up(id)
    # {
    #   "Gosu::GpButton0": Gosu::GpButton0,
    #   "Gosu::GpButton1": Gosu::GpButton1,
    #   "Gosu::GpButton2": Gosu::GpButton2,
    #   "Gosu::GpButton3": Gosu::GpButton3,
    #   "Gosu::GpButton4": Gosu::GpButton4,
    #   "Gosu::GpButton5": Gosu::GpButton5,
    #   "Gosu::GpButton6": Gosu::GpButton6,
    #   "Gosu::GpButton7": Gosu::GpButton7,
    #   "Gosu::GpButton8": Gosu::GpButton8,
    #   "Gosu::GpButton9": Gosu::GpButton9,
    #   "Gosu::GpButton10": Gosu::GpButton10,
    #   "Gosu::GpButton11": Gosu::GpButton11,
    #   "Gosu::GpButton12": Gosu::GpButton12,
    #   "Gosu::GpButton13": Gosu::GpButton13,
    #   "Gosu::GpButton14": Gosu::GpButton14,
    #   "Gosu::GpButton15": Gosu::GpButton15
    # }.each do |constant, value|
    #   puts "Button: #{id} = #{constant}" if value == id
    # end
    @current_game_state.button_up(id)
  end

  def push_game_state(klass, options={})
    @last_game_state = @current_game_state if @current_game_state
    if klass.instance_of?(klass.class) && defined?(klass.options)
      @current_game_state = klass
    else
      klass.new(options)
    end
  end

  def set_game_state(klass_instance)
    @current_game_state = klass_instance
  end

  def previous_game_state
    # current_game_state = @current_game_state
    # @current_game_state = @last_frame_time
    # @last_game_state = current_game_state
    @last_game_state
  end

  def fill_rect(x, y, width, height, color, z = 0)
    Gosu.fill_rect(x,y,width,height,color, z)
  end

  # Sourced from https://gist.github.com/ippa/662583
  def draw_circle(cx,cy,r, z = 9999,color = Gosu::Color::GREEN, step = 10)
    0.step(360, step) do |a1|
      a2 = a1 + step
      draw_line(cx + Gosu.offset_x(a1, r), cy + Gosu.offset_y(a1, r), color, cx + Gosu.offset_x(a2, r), cy + Gosu.offset_y(a2, r), color, z)
    end
  end
end
