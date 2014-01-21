class GameControls
  def initialize
    @text = Chingu::Text.new("How to Play:\n
    Visit planets to build bases, to collect resources.\n
    You have about 10 seconds to prepare before you are\n
    attacked by alien ships.\n
    Controls:\n
    WASD or Arrow keys - Movement\n
    Space - Fire\n
    Boost - Shift\n
    Visit planet - Enter\n
    Upgrade ship: 1, 2, or 3",
    x:200,y:200,zorder:1001, font:"./#{AssetManager.fonts_path}/Alfphabet-IV.ttf", size: 20)
  end

  def draw
    if @show
      $window.fill_rect([100, 100, $window.width-300, $window.height-300], Gosu::Color.argb(100, 0, 0, 0), 1000)
      @text.draw
    end
  end

  def update
    if $window.button_down?(Gosu::KbH)
      @show = true
    else
      @show = false
    end
  end
end