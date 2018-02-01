class GameOver < GameState
  def setup
    @text = Text.new("Game Over", size: 148, color: Gosu::Color::BLACK, shadow_size: 5)
    @time = Text.new("You survived for: #{GameInfo::Config.game_time_processed.strftime('%-H hours, %-M minutes, %-S seconds.')}", size: 28, color: Gosu::Color::BLACK)

    @text.x = $window.width/2-@text.width/2
    @text.y = $window.height/2

    @time.x = $window.width/2-@time.width/2
    @time.y = $window.height/2+220
    @color= 0
    @up = true

    GameMethods.end_cleanup
  end

  def draw
    @text.draw
    @time.draw
  end

  def update
    fade_out_music
    @text.color = Gosu::Color.rgb(@color, 0, 0)
    @time.color = Gosu::Color.argb(@color, 255, 255, 255)
    @color+=2 if @up
    @color-=1 unless @up
    @up = false if @color >= 200

    if @up == false && @color <= 0
      destroy
      $music_manager.song.stop
      push_game_state(MainMenu)
    end
  end

  def button_up(id)
    skip
  end

  def skip
    destroy
    push_game_state(MainMenu)
  end

  def fade_out_music
    $music_manager.song.volume=($music_manager.song.volume-0.0035)
  end
end
