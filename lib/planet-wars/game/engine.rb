class Engine < Chingu::Window
  attr_accessor :show_cursor

  def self.now
    Gosu.milliseconds
  end

  def self.dt
    $window.dt/1000.0
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

    super(width, height, ConfigManager.config["screen"]["fullscreen"], update_interval)
    self.caption = "#{GameInfo::NAME} #{GameInfo::VERSION} [build: #{BUILD}] #{Gosu.language}"
    AssetManager.preload_assets if ARGV.join.include?('--debug')

    # Define GamePad inputs
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton0] = [:gp_0]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton1] = [:gp_1]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton2] = [:gp_2]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton3] = [:gp_3]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton4] = [:gp_4]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton5] = [:gp_5]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton6] = [:gp_6]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton7] = [:gp_7]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton8] = [:gp_8]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton9] = [:gp_9]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton10] = [:gp_10]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton11] = [:gp_11]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton12] = [:gp_12]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton13] = [:gp_13]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton14] = [:gp_14]
    Chingu::Input::CONSTANT_TO_SYMBOL[Gosu::GpButton15] = [:gp_15]

    Logger.log("Window: width: #{width}, height: #{height}, fullscreen: #{fullscreen}, update_interval: #{update_interval}", self)

    if ARGV.join.include?('--net')
      push_game_state(NetGame)
    elsif ARGV.join.include?('--debug')
      push_game_state(Game)
    else
      push_game_state(Boot)
    end

    at_exit do
      @fps_log.close
    end
  end

  def update
    super
    @fps_log.write("#{Gosu.fps}\n")
  end

  def needs_cursor?
    @show_cursor
  end
end
