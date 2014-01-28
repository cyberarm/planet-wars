class GameOver < Chingu::GameState
  trait :timer

  def setup
    @text = Text.new("Game Over", size: 200, color: Gosu::Color::BLACK)
    @text.x = $window.width/2-@text.width/2
    @text.y = $window.height/2
    @color= 0
    @up = true
    self.input = {[:escape] => :skip}

    Planet.destroy_all
    Enemy.destroy_all
    Portal.destroy_all
    Background.destroy_all
    NotificationManager.destroy_all
  end

  def draw
    @text.draw
  end

  def update
    @text.color = Gosu::Color.rgb(@color, 0, 0)
    @color+=2 if @up
    @color-=1 unless @up
    @up = false if @color >= 200

    if @up == false && @color <= 0
      close
      push_game_state(MainMenu)
    end
  end

  def skip
    close
    push_game_state(MainMenu)
  end
end