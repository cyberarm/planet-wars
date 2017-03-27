class PlanetView < Chingu::GameState
  def setup
    @ship   = Ship.all.first
    @planet = @options[:planet]
    @planet.text.text = ''
    @tick = 0 # Prevent jumping from Game to Here back to Game immediately
    @instructions = Text.new("(Enter|Y) Back, (B|B) Build Base", x: 10, size: 25, z: 10_000)
    @name   = Text.new("#{@planet.name}", x: 10, y: 50, size: 25, z: 10_000)
    @base   = Text.new('', x: 10, y: 120, size: 25, z: 10_000)
    @details= Text.new('', x: 10, y: 150, size: 25, z: 10_000)

    @clone  = @planet.clone
    @clone.x = @clone.width+20
    @clone.y = $window.height/2

    self.input = {
      [:enter, :return, :gp_3] => :return_to_game,
      [:b, :gp_1] => :build_base,
      [:r, :gp_2] => :repair_ship
    }
  end

  def draw
    super
    previous_game_state.draw
    fill(AssetManager.theme_color_inverse(AssetManager.theme_data['text']['color'], 200), 9_999)
    @clone.draw
    @instructions.draw
    @name.draw
    @base.draw
    @details.draw
  end

  def update
    @instructions.text = "(Enter|Y) Back, (B|B) Build Base, (R|X) Repair ship" if @planet.base.is_a?(Base)

    if @planet.habitable && @planet.base == nil
      @base.text = "No Base On This Planet"
    elsif @planet.habitable && @planet.base.is_a?(Base)
      @base.text = "Base On This Planet"
    end

    @details.text = "Habitable: #{@planet.habitable}, Diamond: #{@planet.diamond.to_f.round(2)}, Gold: #{@planet.gold.to_f.round(2)}, Oil: #{@planet.oil.to_f.round(2)}"
    @tick+=1
  end


  def created_base
    Base.create(ship: @ship, planet: @planet, x: @planet.x, y: @planet.y)
  end

  def return_to_game
    push_game_state(previous_game_state, setup: false) if @tick >= 30
  end

  def build_base
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

  def repair_ship
    if @planet.base.is_a?(Base) && @ship.oil >= 200 && @ship.health != @ship.max_health
      @ship.oil-=200# unless @ship.health == @ship.max_health
      @ship.health=@ship.max_health
      GameInfo::Config.repaired
    end
  end
end
