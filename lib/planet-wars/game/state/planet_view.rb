class PlanetView < Chingu::GameState
  def setup
    @ship   = Ship.all.first
    @planet = @options[:planet]
    @planet.text.text = ''
    @tick = 0 # Prevent jumping from Game to Here back to Game immediately
    @instructions = Text.new("(Enter) Back, 1. Build Base", x: 10, size: 25)
    @name   = Text.new("#{@planet.name}", x: 10, y: 50, size: 25)
    @base   = Text.new('', x: 10, y: 120, size: 25)
    @details= Text.new('', x: 10, y: 140, size: 25)

    @clone  = @planet.clone
    @clone.x = @clone.width+20
    @clone.y = $window.height/2
  end

  def draw
    super
    fill(AssetManager.theme_color_inverse(AssetManager.theme_data['text']['color']))
    @clone.draw
    @instructions.draw
    @name.draw
    @base.draw
    @details.draw
  end

  def update
    @instructions.text = "(Enter) Back, 1. Build Base, 2. Repair ship" if @planet.base.is_a?(Base)

    if @planet.habitable && @planet.base == nil
      @base.text = "No Base On This Planet"
    elsif @planet.habitable && @planet.base.is_a?(Base)
      @base.text = "Base On This Planet"
    end

    key_check
    @details.text = "Habitable: #{@planet.habitable}, Diamond: #{@planet.diamond.to_f.round(2)}, Gold: #{@planet.gold.to_f.round(2)}, Oil: #{@planet.oil.to_f.round(2)}"
    @tick+=1
  end

  def key_check
    if button_down?(Gosu::KbReturn) or button_down?(Gosu::KbEnter)
      push_game_state(previous_game_state, setup: false) if @tick >= 30
    end

    if button_down?(Gosu::Kb1)
      if @planet.habitable && @ship.gold >= 200
        @ship.gold-=200 unless @planet.base.is_a?(Base)
        @planet.base = created_base unless @planet.base.is_a?(Base)
      elsif @planet.habitable && @ship.diamond >= 20
        @ship.diamond-=20 unless @planet.base.is_a?(Base)
        @planet.base = created_base unless @planet.base.is_a?(Base)
      end

      if !@planet.habitable && @ship.gold >= 400
        @ship.gold-=400 unless @planet.base.is_a?(Base)
        @planet.base = created_base unless @planet.base.is_a?(Base)
        @planet.habitable = true
      elsif !@planet.habitable && @ship.diamond >= 40
        @ship.diamond-=40 unless @planet.base.is_a?(Base)
        @planet.base = created_base unless @planet.base.is_a?(Base)
        @planet.habitable = true
      end
    end

    if button_down?(Gosu::Kb2)
      if @planet.base.is_a?(Base) && @ship.oil >= 200 && @ship.health != @ship.max_health
        @ship.oil-=200# unless @ship.health == @ship.max_health
        @ship.health=@ship.max_health
        GameInfo::Config.repaired
      end
    end
  end

  def button_down?(id)
    $window.button_down?(id)
  end

  def created_base
    Base.new(@planet, x: @planet.x, y: @planet.y)
  end
end
