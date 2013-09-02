class PlanetView < Chingu::GameState
  def setup
    @ship   = Ship.all.first
    @planet = @options[:planet]
    @planet.text.text = ''
    @instructions = Text.new("(Esc) Back, 1. Build Base", x: 10, size: 25)
    @name   = Text.new("#{@planet.name}", x: 10, y: 50, size: 25)
    @base   = Text.new('', x: 10, y: 120, size: 25)
    @details= Text.new('', x: 10, y: 140, size: 25)

    @clone  = @planet.clone
    @clone.x = @clone.width+20
    @clone.y = $window.height/2
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
    @instructions.text = "(Esc) Back, 1. Build Base, 2. Repair ship" if @planet.base.is_a?(Base)

    if @planet.habitable && @planet.base == nil
      @base.text = "No Base On This Planet"
    elsif @planet.habitable && @planet.base.is_a?(Base)
      @base.text = "Base On This Planet"
    end

    unless @planet.habitable
      @base.text = "Can Not Build A Base On This Planet"
    end

    key_check
    @details.text = "Habitable: #{@planet.habitable}, Gold: #{@planet.gold}, Diamond: #{@planet.diamond}, Oil: #{@planet.oil}"
  end

  def key_check
    if button_down?(Gosu::KbEscape) or button_down?(Gosu::KbBackspace)
      push_game_state(previous_game_state, setup: false)
    end

    if button_down?(Gosu::Kb1)
      if @planet.habitable && @ship.gold >= 200
        @ship.gold-=200 unless @planet.base.is_a?(Base)
        @planet.base = Base.new(@planet) unless @planet.base.is_a?(Base)
      elsif @planet.habitable && @ship.diamond >= 20
        @ship.diamond-=20 unless @planet.base.is_a?(Base)
        @planet.base = Base.new(@planet) unless @planet.base.is_a?(Base)
      end
    end

    if button_down?(Gosu::Kb2)
      if @planet.base.is_a?(Base) && @ship.gold >= 200
        @ship.oil-=200 unless @ship.health == @ship.max_health
        @ship.health=@ship.max_health
      end
    end

    if button_down?(Gosu::Kb3)
      @ship.gold+=@planet.gold
      @planet.gold = 0
      @ship.diamond+=@planet.diamond
      @planet.diamond = 0
      @ship.oil+=@planet.oil
      @planet.oil = 0
    end
  end

  def button_down?(id)
    $window.button_down?(id)
  end
end