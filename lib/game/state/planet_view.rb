class PlanetView < Chingu::GameState
  def setup
    @ship   = Ship.all.first
    @planet = @options[:planet]
    @clone  = @planet.clone
    @clone.x = $window.width/2
    @clone.y = $window.height/2
    @planet.text.text = ''
    @instructions = Chingu::Text.new("(Backspace) Back, (B)uild Base, (M)ine Planet.", x: 10)
    @name   = Chingu::Text.new("#{@planet.name}", size: 25, x: 10, y: 50)
    @base   = Chingu::Text.new('No Base On This Planet', x: 10, y: 70)
    @details= Chingu::Text.new('', x: 10, y: 90)
  end

  def draw
    super
    @clone.draw
    @instructions.draw
    @name.draw
    @base.draw
    @details.draw
  end

  def update
    key_check
    @details.text = "Habitable: #{@planet.habitable}\nGold: #{@planet.gold}\nDiamond: #{@planet.diamond}\nOil: #{@planet.oil}"
  end

  def key_check
    if button_down?(Gosu::KbEscape)
      close
      exit
    end

    if button_down?(Gosu::KbBackspace)
      push_game_state(previous_game_state, setup: false)
    end

    if button_down?(Gosu::KbM)
      @ship.gold+=@planet.gold
      @planet.gold = 0
      @ship.gold+=@planet.diamond*10
      @planet.diamond = 0
      @ship.gold+=@planet.oil/10
      @planet.oil = 0
    end
  end

  def button_down?(id)
    $window.button_down?(id)
  end
end