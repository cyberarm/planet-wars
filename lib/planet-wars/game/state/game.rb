class Game < GameState
  include GameMethods
  attr_reader :viewport_x, :viewport_y, :viewport_area
  ViewPortArea = Struct.new(:x, :y, :width, :height)

  def setup
    # clean up
    $window.show_cursor = false
    Ship.destroy_all;Enemy.destroy_all;Planet.destroy_all
    unless defined?($music_manager)
      $music_manager  = MusicManager.new
    else
      $music_manager.song.play if $music_manager.play_songs?
    end

    @viewport_x = 0
    @viewport_y = 0
    @viewport_area = ViewPortArea.new(0,0,6_000,6_000)

    WorldGen.new(42, GameInfo::Config.number_of_portals, @viewport_area.width, @viewport_area.height)
    @ship = Ship.new(x: @viewport_area.width/2, y: @viewport_area.height/2, z: 100,
       world: [@viewport_area.x,@viewport_area.width,@viewport_area.y,@viewport_area.height])#x-left, x-right, y-, y

    @game_hud = GameHUD.new(@viewport_area)
    @game_controls    = GameControls.new
    @game_overlay_hud = GameOverlayHUD.new
    @game_upgrade_hud = GameUpgradeHUD.new(@ship)
    @game_resources_hud = GameResourcesHUD.new(@ship)
    @background       = Background.new(viewport_area: @viewport_area,x: 1500, y: 1500, z: -10)

    NotificationManager.add("GAME STARTING IN 10 SECONDS...", Gosu::Color::GRAY)
    NotificationManager.add("Press 'F1' to show help", Gosu::Color::GRAY)
    AchievementManager.new
    HazardManager.new(viewport_area: @viewport_area)

    @fps           = Text.new('0', x: 10, y: 0)
    @paused_text   = Text.new("PAUSED", x:$window.width/2-200, y: $window.height/2, z: 1000, size: 100)

    @planet_check = 0
    @paused = false
    planet_check unless $debug
    # viewport.lag  = 0.22
  end

  def needs_cursor?
    false
  end

  def draw
    $window.translate(-@viewport_x.to_i, -@viewport_y.to_i) do
      super
    end

    unless @paused
      @fps.draw

      @game_hud.draw
      @game_upgrade_hud.draw
      @game_resources_hud.draw
      @game_overlay_hud.draw
      @game_controls.draw

    else
      @paused_text.draw
    end
  end

  def update
    super
    center_around(@ship)
    unless @paused
      set_fps_text(@fps)

      @game_hud.update unless @global_pause
      @game_upgrade_hud.update
      @game_resources_hud.update
      @game_overlay_hud.update
      @game_controls.update
    end
    if @ship.dead
      @ship.destroy
      push_game_state(GameOver)
    end
    push_game_state(GameWon) if GameInfo::Mode.mode == "wave" && GameInfo::Mode.current_wave >= GameInfo::Mode.waves+1
  end

  # Additional methods
  def needs_cursor?
    true
  end

  def button_up(id)
    @game_controls.button_up(id)

    mute if id == Gosu::KbM
    enter if id == Gosu::KbEnter || id == Gosu::KbReturn || Gosu::GpButton2
    escape if id == Gosu::KbEscape || Gosu::GpButton6
    pause_game if id == Gosu::KbP# || Gosu::GpButton7
    upgrades_menu if id == Gosu::KbU# || Gosu::GpButton3
    debugging_waves if id == Gosu::KbC || id == Gosu::GpButton11 if $debug
    planet_check if id == Gosu::KbV if $debug
    if id == Gosu::KbX && ARGV.join.include?("--debug")
      if $debug
        $debug = false
      else
        $debug = true
      end
    end
    super
  end

  # Adapted from https://github.com/ippa/chingu/blob/d3ed0ff0e0fa81ebc416014095d4ae9b139c785c/lib/chingu/viewport.rb#L132
  def center_around(object)
    x = (object.x - $window.width / 2)
    x = @viewport_area.x if x < @viewport_area.x
    x = @viewport_area.width - $window.width if x > @viewport_area.width - $window.width

    y = (object.y - $window.height/ 2)
    y = @viewport_area.y if y < @viewport_area.y
    y = @viewport_area.height - $window.height if y > @viewport_area.height - $window.height

    @viewport_x = x
    @viewport_y = y
  end

  def planet_check
    unless @planet_checked
      Planet.each_circle_collision(Planet) do |one, two|
        two.destroy
      end
    end

    @planet_checked = true
  end

  def pause_game
    if @paused
      game_objects.each(&:unpause)
      $music_manager.song.play if defined?($music_manager)
      @paused = false
    else
      game_objects.each(&:pause)
      $music_manager.song.pause if defined?($music_manager)
      @paused = true
    end
  end

  def mute
    if $mute; $mute = false; else; $mute = true; end
    if $music_manager.song.paused?
      $music_manager.song.play
    else
      $music_manager.song.pause
    end
  end

  def enter
    # TODO: Change each to first
    Planet.each_circle_collision(@ship) do |planet, ship|
      push_game_state(PlanetView.new(planet: planet, game: self))
    end
  end

  def escape
    ask("Are you sure you want to leave?") do
      @ship.destroy
      GameMethods.end_cleanup
      destroy
      push_game_state(MainMenu)
    end
  end

  def upgrades_menu
    push_game_state(ShipUpgrades.new(game: self))
  end

  def debugging_waves
    puts "Enemies active: #{Enemy.all.count}"
    puts "GameInfo::Mode.wave_enemies_spawned: #{GameInfo::Mode.wave_enemies_spawned}"
    puts "GameInfo::Mode.wave_spawned? #{GameInfo::Mode.wave_spawned?}"
    puts "GameInfo::Mode.current_wave: #{GameInfo::Mode.current_wave}"
  end
end
