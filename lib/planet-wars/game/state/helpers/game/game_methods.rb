module GameMethods
  def set_fps_text(fps_text)
    @fps = fps_text
    fps = $window.fps
    @fps.text = "FPS: #{fps}"
    if fps >= 60
      @fps.color = Gosu::Color::WHITE
    end
    if fps <= 57
      @fps.color = Gosu::Color::GREEN
    end
    if fps <= 45
      @fps.color = Gosu::Color::YELLOW
    end
    if fps <= 30
      @fps.color = Gosu::Color::RED
    end
    if fps <= 15
      @fps.color = Gosu::Color::FUCHSIA
    end
  end

  def ask(string, &blk)
    push_game_state(Confirm.new(text: string, block: blk)) if blk
    push_game_state(Confirm.new(text: string, block: blk)) unless blk
  end

  def self.end_cleanup
    Planet.destroy_all
    Enemy.destroy_all
    Portal.destroy_all
    Background.destroy_all
    Target.destroy_all
    Asteroid.destroy_all
    HazardManager.destroy_all
    NotificationManager.destroy_all
    $music_manager.song.stop

    GameInfo::Mode.wave_enemies_spawned=0
    GameInfo::Mode.wave_spawned = false
    GameInfo::Mode.current_wave = 1
    # Additional GameInfo resets.
  end
end