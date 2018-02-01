class Boot < GameState
  def setup
    @title  = Text.new(GameInfo::NAME, alignment: :center, y: $window.height/2-50, z: 1, size: 100, color: Gosu::Color::WHITE, shadow_size: 2)
    @author_color = Gosu::Color.rgba(255, 127, 0, 0)
    @author = Text.new("Created by: Cyberarm", alignment: :center, y: $window.height/2+75, z: 1, size: 32, color: @author_color)
    @num = 0
  end

  def draw
    super
    @author.draw
    @title.draw
  end

  def update
    @author_color.alpha+=2 if @num > 45
    if @num > 1 && !@assets_loaded # Render scene before preload
      AssetManager.preload_assets
      @assets_loaded = true
    end

    push_game_state(MainMenu) if @num >= 256
    @num += 1
  end
end
