class Engine < Chingu::Window
  def initialize
    super(Gosu.screen_width, Gosu.screen_height, true) unless ARGV.join.include?("--low")
    super(Gosu.screen_width/4*3, Gosu.screen_height/4*3, true) if ARGV.join.include?("--low")
    puts "LOW MODE Resolution: #{$window.width} x #{$window.height}" if ARGV.join.include?("--low")
    # super(1280, 768, true) # Test screen size to ensure game works at that resolution
    self.caption = "#{GameInfo::NAME} (#{GameInfo::VERSION}) [build: #{BUILD}] #{Gosu.language}"

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

    push_game_state(Boot) unless ARGV.join.include?('--debug')
    push_game_state(Game) if ARGV.join.include?('--debug')
  end

  def needs_cursor?
    false
  end
end