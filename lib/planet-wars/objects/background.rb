class Background < GameObject
  Star = Struct.new(:x, :y, :alpha, :size, :color)
  def setup
    @debug_color = Gosu::Color::BLACK
    @game = $window.current_game_state if $window.current_game_state.is_a?(Game)

    @area = @options[:viewport_area]
    @stars = []
    generate_stars
  end

  def generate_stars
    1000.times do |i|
      color_r = rand(100..255)
      s = Star.new(rand(@area.width), rand(@area.height), rand(50..255), rand(2..8), Gosu::Color.rgba(color_r,color_r,color_r,255))
      s.color.alpha = s.alpha
      @stars << s
    end
  end

  def draw
    if @game && @game.is_a?(Game)
      @stars.each do |star|
        if star.alpha >= 200
          $window.draw_rect(star.x, star.y, star.size, star.size, star.color)
        else
          $window.draw_rect(star.x-(@game.viewport_x/4), star.y-(@game.viewport_y/4), star.size, star.size, star.color)
        end
      end
    end
  end

  def update
    @game = $window.current_game_state if !@game.is_a?(Game) && $window.current_game_state.is_a?(Game)
  end
end
