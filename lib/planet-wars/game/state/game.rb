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
      $music_manager.song.play unless $music_manager.play_songs?
    end

    # set controls
    self.input = {[:m] => :mute, [:enter, :return] => :enter, [:escape, :gp_6] => :escape, [:p, :gp_7] => :pause_game}

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
    Planet.each_bounding_circle_collision(@ship) do |planet, ship|
      push_game_state(PlanetView.new(planet: planet))
    end
  end

  def escape
    ask("Are you sure you want to leave?") do
      @ship.destroy
      Planet.destroy_all
      Enemy.destroy_all
      Portal.destroy_all
      Background.destroy_all
      Target.destroy_all
      Asteroid.destroy_all
      HazardManager.destroy_all
      NotificationManager.destroy_all
      $music_manager.song.pause
      close
      push_game_state(MainMenu)
    end
  end

  def button_up(id)
    @ship.upgrade_speed if id == (Gosu::Kb1)
    @ship.upgrade_boost_speed if id == (Gosu::Kb2)
    @ship.upgrade_boost_capacity if id == (Gosu::Kb3)
  end
end