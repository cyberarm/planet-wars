class PlanetView < GameUI
  def create
    set_title("")
    if !options[:planet].base.is_a?(Base)
      button "Build Base", x: 400, tooltip: "#{options[:planet].habitable ? '20 Diamond — 200 Gold' : '40 Diamond — 400 Gold'}" do
        build_base
      end
    end
    if options[:planet].base.is_a?(Base)
      button "Repair Ship", x: 400, tooltip: "200 Oil" do
        repair_ship
      end
    end
    button "Back", x: 400 do
      return_to_game
    end

    @ship   = Ship.all.first
    @planet = @options[:planet]
    @planet.text.text = ''
    @name   = Text.new("Planet #{@planet.name}", x: 10, y: 10, size: 30, z: 10_000)
    @base   = Text.new('', x: 10, y: 50, size: 25, z: 10_000)
    @habitable = Text.new('', x: 10, y: 100, size: 25, z: 10_000)
    @diamond= Text.new('', x: 10, y: 130, size: 25, z: 10_000)
    @gold   = Text.new('', x: 10, y: 160, size: 25, z: 10_000)
    @oil    = Text.new('', x: 10, y: 190, size: 25, z: 10_000)
    @resources = Text.new("")

    @clone  = @planet.clone
    @clone.z = 0
    @clone.x = @clone.width+20
    @clone.y = $window.height/2
  end

  def draw
    super
    # previous_game_state.draw
    @clone.draw if @clone
    fill_rect(10, 40, $window.width-20, 4, Gosu::Color::WHITE, Float::INFINITY)
    @name.draw
    @base.draw
    @habitable.draw
    @diamond.draw
    @gold.draw
    @oil.draw
    @resources.draw
  end

  def update
    super
    @clone.rotate_self if @clone
    if @planet.habitable && @planet.base == nil
      @base.text = "No Base On This Planet"
    elsif @planet.habitable && @planet.base.is_a?(Base)
      @base.text = "Base On This Planet"
    end

    @resources = MultiLineText.new("Your Resources\n\n#{@ship.diamond.round(2)} Diamond\n#{@ship.gold.round(2)} Gold\n#{@ship.oil.round(2)} Oil", x: 10, y: 225, size: 25, z: 10_000)

    @habitable.text = "Habitable: #{@planet.habitable}"
    @diamond.text = "Diamond: #{@planet.diamond.to_f.round(2)}"
    @gold.text    = "Gold: #{@planet.gold.to_f.round(2)}"
    @oil.text     = "Oil: #{@planet.oil.to_f.round(2)}"
  end


  def created_base
    Base.new(ship: @ship, planet: @planet, x: @planet.x, y: @planet.y)
  end

  def return_to_game
    @clone.destroy if @clone
    $window.show_cursor = false
    push_game_state(@options[:game])
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

    refresh
  end

  def repair_ship
    if @planet.base.is_a?(Base) && @ship.oil >= 200 && @ship.health != @ship.max_health
      @ship.oil-=200# unless @ship.health == @ship.max_health
      @ship.health=@ship.max_health
      GameInfo::Config.repaired
    end
  end

  def refresh
    push_game_state(PlanetView.new(planet: @planet, game: @options[:game]))
  end
end
