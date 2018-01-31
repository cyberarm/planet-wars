# class GameControls
#   def initialize
#     @text = Chingu::Text.new("How to Play:\n
#     Visit planets to build bases, to collect resources.\n
#     You have about 10 seconds to prepare before you are\n
#     attacked by alien ships.\n
#     Controls:\n
#     Movement - WASD or Arrow keys\n
#     Fire - Spacebar\n
#     Boost - Shift\n
#     Visit planet - Enter\n
#     Upgrade ship: U",
#     x:200,y:200,z:1001, font:"#{AssetManager.fonts_path}/Alfphabet-IV.ttf", size: 20)
#   end
#
#   def draw
#     if @show
#       $window.fill_rect([100, 100, $window.width-300, $window.height-300], Gosu::Color.argb(100, 0, 0, 0), 1000)
#       @text.draw
#     end
#   end
#
#   def update
#     if $window.button_down?(Gosu::KbH)
#       @show = true
#     else
#       @show = false
#     end
#   end
# end
