class Boot < Chingu::GameState
  def setup
    @title  = Text.new(GameInfo::NAME, x: 100, y: $window.height-400, z: 1, size: 100, color: Gosu::Color::WHITE)
    @author = Text.new("Created by: Cyberarm", x: 100, y: $window.height-300, z: 1, size: 60, color: Gosu::Color.rgb(255, 127, 0))
    @num = 0
  end

  def draw
    super
    @author.draw
    @title.draw
  end

  def update
    if @num > 5 && !@assets_loaded # Render scene before preload
      AssetManager.preload_assets
      @assets_loaded = true
    end

    push_game_state(MainMenu) if @num >= 120
    @num += 1
  end
end
