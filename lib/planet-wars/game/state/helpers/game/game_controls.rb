class GameControls
  def initialize
    @text = MultiLineText.new("How to Play:\n
    Visit planets to build bases, to collect resources.\n
    You have about 10 seconds to prepare before you are\n
    attacked by enemy ships.\n
    Controls:\n
    Movement - WASD or Arrow keys\n
    Fire - Spacebar\n
    Boost - Shift\n
    Visit planet - Enter\n
    Upgrade ship: U",
    x:200,y:200,z:1001, size: 20)
  end

  def draw
    if @show
      $window.flush
      $window.draw_rect(0, 0, $window.width, $window.height, Gosu::Color.argb(200, 0, 0, 0), 1000)
      @text.draw
    end
  end

  def update
    if $window.button_down?(Gosu::KbF1) || $window.button_down?(Gosu::GpButton7)
      $window.current_game_state.global_pause = true
      @show = true
    else
      @show = false
    end
  end

  def button_up(id)
    $window.current_game_state.global_pause = false if (id == Gosu::KbF1 || id == Gosu::GpButton7) && $window.current_game_state.global_pause
  end
end
