class Portal < Chingu::GameObject
  trait :timer
  trait :effect

  def setup
    @image = Gosu::Image["#{AssetManager.portal_path}/portal.png"]
    self.alpha = 0
    self.scale = 0.6

    every(1500) do
      spawn_enemy
    end

    every(4000) do
      if self.alpha <= 0
        self.x = rand(100..@options[:world_width]-100)
        self.y = rand(100..@options[:world_height]-100)
      end
    end
  end

  def draw
    super
  end

  def update
    if @ready
      fade_out(3) unless @spawn
      fade_in(3) if @spawn
    end

    if Time.now-GameInfo::Config.game_time > 10
      @ready = true
    end

    if GameInfo::Mode.mode == "wave"
      @spawn = false unless GameInfo::Mode.wave_enemies_spawned <= GameInfo::Config.number_of_enemies && GameInfo::Mode.wave_spawned?
      @spawn = true if self.alpha <= 255 && GameInfo::Mode.wave_enemies_spawned <= GameInfo::Config.number_of_enemies && !GameInfo::Mode.wave_spawned?
    else
      @spawn = true if self.alpha <= 255 && Enemy.all.count <= GameInfo::Config.number_of_enemies
      @spawn = false unless Enemy.all.count <= GameInfo::Config.number_of_enemies
    end
  end

  def spawn_enemy
    if GameInfo::Mode.mode == "wave"
      if wave_processor && @ready && @spawn
        if GameInfo::Mode.wave_enemies_spawned <= GameInfo::Config.number_of_enemies
          Enemy.spawn(self)
        end
      end
    else
      Enemy.spawn(self) if @ready && @spawn && Enemy.all.count <= GameInfo::Config.number_of_enemies
    end
  end

  def wave_processor
    GameInfo::Mode.wave_enemies_spawned=0 if Enemy.all.count == 0 && GameInfo::Mode.wave_spawned?

    if GameInfo::Mode.wave_enemies_spawned <= GameInfo::Config.number_of_enemies && !GameInfo::Mode.wave_spawned?
      GameInfo::Mode.wave_spawned = true if Enemy.all.count >= GameInfo::Config.number_of_enemies
      true
    else
      if GameInfo::Mode.wave_spawned? && Enemy.all.count <= 0
        GameInfo::Mode.current_wave+=1
        GameInfo::Mode.wave_enemies_spawned = 0
        GameInfo::Mode.wave_spawned = false
        return true
      else
        false
      end
    end
  end
end
