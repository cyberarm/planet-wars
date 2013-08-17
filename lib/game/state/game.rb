class Game < Chingu::GameState
  trait :timer
  trait :viewport

  def setup
    self.input = {[:enter, :return] => :enter, [:escape, :gp_6] => :escape, [:p, :gp_7] => :pause_game}

    @music  = MusicManager.create unless ARGV.first == '-d' or defined?(@music)
    @paused = false

    WorldGen.new(40, 3000, 3000)
    @ship = Ship.create(x: 3000/2, y: 3000/2, zorder: 100, world: [0,3000,0,3000])#x-left, x-right, y-, y

    @fps           = Text.new('', x: 10, y: 0)
    @instructions  = Text.new('Upgrades', x: $window.width-(30*10), y: 400, size: 40)
    @upgrade_speed_text  = Text.new('', x: $window.width-(30*10), y: 450, size: 11)
    @upgrade_boost_text  = Text.new('', x: $window.width-(30*10), y: 460, size: 11)
    @upgrade_boosc_text  = Text.new('', x: $window.width-(30*10), y: 470, size: 11)
    @paused_text   = Text.new("PAUSED", x:$window.width/2-200, y: $window.height/2, z: 1000, size: 100)

    @minimap      = MiniMap.new
    @boost_bar    = BoostBar.new
    @health_bar   = HealthBar.new

    @planet_check = 0

    viewport.lag  = 0.22
    viewport.game_area = [0, 0, 1000*3, 1000*3]
  end

  def needs_cursor?
    false
  end

  def draw
    super
    unless @paused
      @fps.draw
      @boost_bar.draw
      @health_bar.draw
      @instructions.draw
      @upgrade_speed_text.draw
      @upgrade_boost_text.draw
      @upgrade_boosc_text.draw
      @minimap.draw
    else
      @paused_text.draw
    end
  end

  def update
    super
    self.viewport.center_around(@ship)
    set_fps_text_data
    unless @paused
      @minimap.update
      @health_bar.update
      @boost_bar.update

      @upgrade_speed_text.text = "1. Speed: #{@ship.speed}"
      @upgrade_boost_text.text = "2. Boost Speed: #{@ship.boost_speed}"
      @upgrade_boosc_text.text = "3. Boost Capacity: #{@ship.max_boost}"

      planet_check
    end
  end

  def set_fps_text_data
    fps = $window.fps
    @fps.text = "FPS: #{fps}"
    if fps >= 60
      @fps.color = Gosu::Color::WHITE
    end
    if fps <= 57
      @fps.color = Gosu::Color::GREEN
    end
    if fps <= 45
      @fps.color = Gosu::Color::YELLOW
    end
    if fps <= 30
      @fps.color = Gosu::Color::RED
    end
    if fps <= 15
      @fps.color = Gosu::Color::FUCHSIA
    end
  end

  def needs_cursor?
    true
  end

  def planet_check
    unless @planet_checked
      Planet.each_collision(Planet) do |one, two|
        two.destroy
      end
    end

    @planet_checked = true
  end

  def pause_game
    if @paused
      game_objects.each(&:unpause)
      @music.song.play
      @paused = false
    else
      game_objects.each(&:pause)
      @music.song.pause
      @paused = true
    end
  end

  def enter
    Planet.each_bounding_circle_collision(@ship) do |planet, ship|
      push_game_state(PlanetView.new(planet: planet))
    end
  end

  def escape
    @ship.destroy
    Planet.destroy_all
    Enemy.destroy_all
    @music.destroy if defined?(@music)
    close
    push_game_state(MainMenu)
  end

  def upgrade
    push_game_state(UpgradeShip)
  end
end