class Engine < Chingu::Window
  def initialize
    super(Gosu.screen_width, Gosu.screen_height, true)
    self.caption = "Planet Wars (#{PlanetWars::VERSION}) [test: #{BUILD}] #{Gosu.language}"

    push_game_state(Boot)
  end

  def needs_cursor?
    false
  end
end