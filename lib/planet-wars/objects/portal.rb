# Portal
# Spawns enemies and handles Waves.

class Portal < Chingu::GameObject
  trait :timer
  trait :effect

  def setup
    @image = Gosu::Image["#{AssetManager.portal_path}/portal.png"]
    self.alpha = 0
    self.scale = 0.6
    @fade_speed = 3*60

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
      fade_speed = @fade_speed*Engine.dt

      fade_out(fade_speed) unless @spawn or @despawn
      fade_in(fade_speed) if @spawn or @despawn
    end

    if Time.now-GameInfo::Config.game_time > 10
      @ready = true
    end

    if GameInfo::Mode.mode == "wave"
      @spawn = false unless GameInfo::Mode.wave_enemies_spawned <= GameInfo::Config.number_of_enemies && GameInfo::Mode.wave_spawned?
      @spawn = true if GameInfo::Mode.wave_enemies_spawned <= GameInfo::Config.number_of_enemies && !GameInfo::Mode.wave_spawned?
    else
      @spawn = true if Enemy.all.count <= GameInfo::Config.number_of_enemies
      @spawn = false unless Enemy.all.count <= GameInfo::Config.number_of_enemies
    end
  end

  def despawn(boolean)
    @despawn = boolean
  end

  def spawn_enemy
    if GameInfo::Mode.mode == "wave"
      if wave_processor && @ready && self.alpha >= 255 && @spawn
        if GameInfo::Mode.wave_enemies_spawned <= GameInfo::Config.number_of_enemies
          Enemy.spawn(self)
        end
      end
    else
      Enemy.spawn(self) if @ready && self.alpha >= 255 && @spawn && Enemy.all.count <= GameInfo::Config.number_of_enemies
    end
  end

  def wave_processor
    GameInfo::Mode.wave_enemies_spawned=0 if Enemy.all.count == 0 && GameInfo::Mode.wave_spawned?

    if GameInfo::Mode.wave_enemies_spawned <= GameInfo::Config.number_of_enemies && !GameInfo::Mode.wave_spawned?
      GameInfo::Mode.wave_spawned = true if Enemy.all.count >= GameInfo::Config.number_of_enemies
      true
    elsif GameInfo::Mode.wave_spawned? && Enemy.all.count <= 0
        GameInfo::Mode.current_wave+=1
        GameInfo::Mode.wave_enemies_spawned = 0
        GameInfo::Mode.wave_spawned = false
        true
    else
      false
    end
  end
end
