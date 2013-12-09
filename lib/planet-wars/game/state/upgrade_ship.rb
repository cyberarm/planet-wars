class UpgradeShip < Chingu::GameState
  def setup
    @ship = Ship.all.first
    @instructions = Chingu::Text.new("(Backspace) Back, Upgrade max b(O)ost, Upgrade boost (E)fficiency, Upgrade (S)peed.", x: 10)
    @title = Chingu::Text.new("Ship Upgrades", x: 10, y: 20, size: 25)
    @details = Chingu::Text.new("", x: 10, y: 50)
    @lock_max_boost = 400
    @lock_boost_speed = 15
    @lock_speed = 20
  end

  def draw
    super
    @instructions.draw
    @title.draw
    @details.draw
  end

  def update
    key_check
    @details.text = "Max Boost: #{@ship.max_boost}\nBoost Speed: #{@ship.boost_speed}\nSpeed: #{@ship.speed}"
  end

  def key_check
    if button_down?(Gosu::KbEscape)
      close
      exit
    end

    if button_down?(Gosu::KbBackspace)
      push_game_state(previous_game_state, setup: false)
    end

    if button_down?(Gosu::KbO)
      @ship.max_boost+=1 unless @ship.max_boost >= @lock_max_boost
    end

    if button_down?(Gosu::KbE)
      @ship.boost_speed+=1 unless @ship.boost_speed >= @lock_boost_speed
    end

    if button_down?(Gosu::KbS)
      @ship.speed+=1 unless @ship.speed >= @lock_speed
    end
  end

  def button_down?(id)
    $window.button_down?(id)
  end
end