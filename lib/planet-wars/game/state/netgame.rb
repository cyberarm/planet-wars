class NetGame < Chingu::GameState
  trait :timer
  trait :viewport

  def setup
    # clean up
    Ship.destroy_all
    Enemy.destroy_all
    Planet.destroy_all
    @host   = @options[:host]
    @client = @options[:client]
    @server = Network::Server.new

    # set controls
    self.input = {[:m] => :mute, [:escape, :gp_6] => :escape}

    @paused = false

    WorldGen.new(40, 3000, 3000)
    @ship = Ship.create(x: 3000/2, y: 3000/2, zorder: 100, world: [0,3000,0,3000])#x-left, x-right, y-, y

    @fps           = Text.new('', x: 10, y: 0)
    @minimap      = MiniMap.new
    @boost_bar    = BoostBar.new
    @health_bar   = HealthBar.new
    @updates = 0

    @planet_check = 0

    viewport.lag  = 0.22
    viewport.game_area = [0, 0, 1000*3, 1000*3]
  end

  def needs_cursor?
    false
  end

  def draw
    super
    @fps.draw
    @boost_bar.draw
    @health_bar.draw

    @minimap.draw
  end

  def update
    super
    @updates+=0
    if @updates >= 5
      # GameOverseer::MessageManager::MESSAGES << "#{Marshal.dump({:player => []})}"#, enemies: Enemy.all, bullets: Bullet.all
      GameOverseer::MessageManager::MESSAGES << ""
      @updates = 0
    end
    self.viewport.center_around(@ship)
    set_fps_text_data
    @minimap.update
    @health_bar.update
    @boost_bar.update

    planet_check

    if @ship.dead
      @ship.destroy
      Planet.destroy_all
      Enemy.destroy_all
      push_game_state(GameOver)
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

  def mute
    if @paused
      $music_manager.song.play
    else
      $music_manager.song.pause
    end
  end

  def escape
    @ship.destroy
    Planet.destroy_all
    Enemy.destroy_all
    @server.server.close
    close
    push_game_state(MainMenu)
  end
end