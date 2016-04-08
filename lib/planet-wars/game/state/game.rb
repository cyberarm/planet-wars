class Game < Chingu::GameState
  trait :timer
  trait :viewport
  include GameMethods

  def setup
    # clean up
    $window.show_cursor = false
    Ship.destroy_all;Enemy.destroy_all;Planet.destroy_all;Background.create(x: 1500, y: 1500, zorder: -10)
    unless defined?($music_manager)
      $music_manager  = MusicManager.create
    else
      $music_manager.song.play if $music_manager.play_songs?
    end

    # set controls
    self.input = {
      [:m] => :mute,
      [:enter, :return, :gp_3] => :enter,
      [:escape, :gp_6] => :escape,
      [:p, :gp_4] => :pause_game,
      [:u, :gp_2] => :upgrades_menu,
      [:c] => :debugging_waves
    }

    WorldGen.new(40, GameInfo::Config.number_of_portals, 3000, 3000)
    @ship = Ship.create(x: 3000/2, y: 3000/2, zorder: 100, world: [0,3000,0,3000])#x-left, x-right, y-, y

    @game_hud = GameHUD.new
    @game_controls    = GameControls.new
    @game_overlay_hud = GameOverlayHUD.new
    @game_upgrade_hud = GameUpgradeHUD.new(@ship)
    @game_resources_hud = GameResourcesHUD.new(@ship)

    NotificationManager.add("GAME STARTING IN 10 SECONDS...", Gosu::Color::GRAY)
    NotificationManager.add("Press 'H' to show help", Gosu::Color::GRAY)
    AchievementManager.create
    HazardManager.create

    @fps           = Text.new('', x: 10, y: 0)
    @paused_text   = Text.new("PAUSED", x:$window.width/2-200, y: $window.height/2, z: 1000, size: 100)

    @planet_check = 0
    @paused = false
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

      @game_hud.draw
      @game_controls.draw
      @game_overlay_hud.draw
      @game_upgrade_hud.draw
      @game_resources_hud.draw

    else
      @paused_text.draw
    end
  end

  def update
    super
    self.viewport.center_around(@ship)
    unless @paused
      set_fps_text(@fps)

      @game_hud.update
      @game_controls.update
      @game_overlay_hud.update
      @game_upgrade_hud.update
      @game_resources_hud.update

      planet_check
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
      $music_manager.song.play if defined?($music_manager)
      @paused = false
    else
      game_objects.each(&:pause)
      $music_manager.song.pause if defined?($music_manager)
      @paused = true
    end
  end

  def mute
    if $music_manager.song.paused?
      $music_manager.song.play
    else
      $music_manager.song.pause
    end
  end

  def enter
    # TODO: Change each to first
    Planet.each_bounding_circle_collision(@ship) do |planet, ship|
      push_game_state(PlanetView.new(planet: planet))
    end
  end

  def escape
    ask("Are you sure you want to leave?") do
      @ship.destroy
      GameMethods.end_cleanup
      close
      push_game_state(MainMenu)
    end
  end

  def upgrades_menu
    push_game_state(ShipUpgrades)
  end

  def debugging_waves
    puts "Enemies active: #{Enemy.all.count}"
    puts "GameInfo::Mode.wave_enemies_spawned: #{GameInfo::Mode.wave_enemies_spawned}"
    puts "GameInfo::Mode.wave_spawned? #{GameInfo::Mode.wave_spawned?}"
    puts "GameInfo::Mode.current_wave: #{GameInfo::Mode.current_wave}"
  end
end
