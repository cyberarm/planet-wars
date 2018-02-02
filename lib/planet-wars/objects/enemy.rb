class Enemy < GameObject
  attr_accessor :move, :health, :target, :target_area, :speed, :dx, :dy, :target_object
  attr_reader :despawn, :old_gosu_time

  def setup
    @debug_color = Gosu::Color::RED

    self.z = 300
    self.alpha = 0
    @speed = 2*60
    @health= 60
    GameInfo::Mode.wave_enemies_spawned+=1
    @image = AssetManager.get_image("#{AssetManager.enemies_path}/enemy.png")
    @target = Target.new(x: 0, y: 0, target: Ship.all.first) unless Target.all.first.is_a?(Target)
    @target = Target.all.first if Target.all.first.is_a?(Target)
    @target_area = TargetArea.new(owner: self, target: @target, size: 255.0)
    @ai = EnemyAI.new(self)
    @dx = 0
    @dy = 0
  end

  def draw
    super
    if @target_object && $debug
      $window.draw_line(self.x, self.y, Gosu::Color.rgb(200,100,100),
                        @target_object.x, @target_object.y, Gosu::Color.rgb(200,100,100), 9999)
    end
  end

  def update
    self.alpha+=2 unless @despawn
    look_at(@target) if @target

    @ai.update
    if self.alpha >= 255 && !@despawn
      @ai.state = :seek    if !@target_area.in_range
      @ai.state = :attack  if @target_area.in_range
      @ai.state = :retreat if @health <= 30 && GameInfo::Mode.mode == 'survival' # FIXME: despawning an enemy in 'wave' mode should cause a respawn instead if having a free win for damaging enemies.
    end

    if @despawn && @portal.alpha >= 255
      alpha = 120*Engine.dt
      self.alpha-=alpha
      self.destroy if self.alpha <= 0
    end

    check_health
  end

  def fire_bullet!
    speed = Bullet.speed*Engine.dt
    distance   = Gosu.distance(self.x, self.y, @target.x, @target.y)
    dx = 0
    dy = 0
    if distance >= 500 && @target.speed >= 1
      _heading = @target.heading(distance*0.5)
      dx = _heading.x - self.x
      dy = _heading.y - self.y
    else
      dx = @target.x - self.x
      dy = @target.y - self.y
    end
    length = Math.sqrt( dx*dx + dy*dy )
    dx /= length; dy /= length
    dx *= speed; dy *= speed

    _angle = ((Math.atan2(dy, dx) * 180) / Math::PI) + 90 # Black magic
    Bullet.new(x: self.x, y: self.y, z: 199, host_angle: _angle, created_by: self) if @target_area.in_range && self.alpha >= 255
  end

  def check_health
    if @health <= 0
      Empty.new(x: self.x, y: self.y)
      AssetManager.get_sample("#{AssetManager.sounds_path}/explosion.ogg").play if ConfigManager.play_sounds?
      GameInfo::Kills.killed if @object.is_a?(Bullet)
      self.destroy
    end
  end

  def hit(damage, object)
    @object = object
    @health-=damage if self.alpha >= 255
  end

  def destroy
    super
    Portal.all.each {|portal| portal.despawn(false)}
    # TODO: Respawn enemies that despawn during Wave gamemode
    # GameInfo::Mode.wave_enemies_spawned-=1 if defined?(@portal) && @health >= 1
    @target_area.destroy
  end

  def self.spawn(portal)
    Enemy.new(x: portal.x, y: portal.y)
  end

  def despawn(portal)
    @despawn = true
    @portal  = portal
  end

  # TODO: Move to Chingu::GameObject to embed in all game objects
  def find_closest(game_object)
    best_object = nil
    best_distance = 100_000_000_000 # Huge default number

    game_object.all.each do |object|
      distance = Gosu::distance(self.x, self.y, object.x, object.y)
      if distance <= best_distance
        best_object = object
        best_distance = distance
      end
    end

    return best_object
  end

  def look_at(object)
  end
end
