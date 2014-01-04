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

  def ask(string)
    push_game_state(Confirm.new(text: string))
  end
end