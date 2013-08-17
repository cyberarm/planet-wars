class Boot < Chingu::GameState
  trait :timer
  def setup
    @title  = Text.new(GameInfo::NAME, x: $window.width/2, y: $window.height-400, z: 1, size: 100)
    @author = Text.new("Created by: Cyberarm", x: $window.width/2, y: $window.height-300, z: 1, size: 60, color: Gosu::Color.rgb(255, 127, 0))#, color: Gosu::Color::BLUE)
    AssetManager.preload_assets # FIXME: Requires timer to continue to MainMenu
    after(3000) do
      push_game_state(MainMenu)
    end
  end

  def draw
    super
    @author.draw
    @title.draw
  end
end