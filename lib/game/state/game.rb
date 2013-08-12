class Game < Chingu::GameState
  trait :timer
  trait :viewport

  def setup
    Gosu::enable_undocumented_retrofication
    @music = MusicManager.new unless ARGV.first == '-d'
    @paused = false

    WorldGen.new(40, 3000, 3000)
    @ship = Ship.create(x: 3000/2, y: 3000/2, zorder: 100, world: [0,3000,0,3000])#x-left, x-right, y-, y

    @fps           = Text.new('', x: 10, y: 0)
    @ship_location = Text.new('', x: 10, y: 30)
    @ship_boost    = Text.new('', x: 10, y: 60)
    @instructions  = Text.new('(U)pgrade Ship, (Enter) Explore Planet, (M)anage all Planets.', x: 10, y: 90)
    @debug_text    = Text.new("", x:10, y: 100)
    @paused_text   = Text.new("PAUSED", x:$window.width/2-200, y: $window.height/2, z: 1000, size: 100)

    @minimap = MiniMap.new

    @planet_check = 0

    viewport.lag  = 0.22
    viewport.game_area = [0, 0, 1000*3, 1000*3]
  end

  def draw
    super
    @fps.draw
    @ship_location.draw
    @ship_boost.draw
    @instructions.draw
    @minimap.draw
    @debug_text.draw
    @paused_text.draw if @paused
  end

  def update
    super
    MiniMap.all.first.update
    @debug_text.text = "A:#{@ship.acceleration}; V:#{@ship.velocity};"
    @fps.text = "FPS: #{$window.fps}"
    @ship_location.text = "X: #{@ship.x} Y: #{@ship.y}"
    @ship_boost.text = "Boost: #{@ship.boost}"
    self.viewport.center_around(@ship)

    planet_check
    key_check
  end

  def needs_cursor?
    true
  end

  def planet_check
    if @planet_check >= 3
      Planet.each_collision(Planet) do |one, two|
        two.destroy
        Planet.create(x: rand($window.width), y: rand($window.height), zorder: 0) unless $window.fps < 30
      end

    end

    Planet.each_bounding_circle_collision(Ship.all.first) do |planet, ship|
      if button_down?(Gosu::KbEnter) or button_down?(Gosu::KbReturn)
        push_game_state(PlanetView.new(planet: planet))
      end
    end

    @planet_check += 1
  end

  def key_check
    if button_down?(Gosu::KbEscape)
      close
      exit
    end

    if button_down?(Gosu::KbU)
      push_game_state(UpgradeShip)
    end
  end

  def button_down?(id)
    $window.button_down?(id)
  end

  def button_up(id)
    case id
    when Gosu::KbP
      if @paused
        game_objects.each(&:unpause)
        puts "Unpaused"
        @paused = false
      else
        game_objects.each(&:pause)
        puts "Paused"
        @paused = true
      end
    end
  end
end