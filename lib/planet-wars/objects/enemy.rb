class Enemy < Chingu::GameObject
  attr_accessor :move, :health, :tick, :target, :target_area, :speed, :dx, :dy
  attr_reader :despawn

  trait :effect
  trait :bounding_circle
  trait :collision_detection

  def setup
    self.zorder = 300
    self.alpha = 0
    @speed = 2
    @health= 40
    GameInfo::Mode.wave_enemies_spawned+=1
    @image = Gosu::Image["#{AssetManager.enemies_path}/enemy.png"]
    @target = Target.create(x: 0, y: 0, target: Ship.all.first) unless Target.all.first.is_a?(Target)
    @target = Target.all.first if Target.all.first.is_a?(Target)
    @target_area = TargetArea.create(owner: self, target: @target, size: 255.0)
    @ai = EnemyAI.new(self)
    @tick = 0
    @dx = 0
    @dy = 0
  end

  def update
    self.alpha+=2 unless @despawn
    rotate(rand(0.0..1.0))

    @ai.update
    if self.alpha >= 255 && !@despawn
      @ai.state = :seek    if !@target_area.in_range
      @ai.state = :attack  if @target_area.in_range
      @ai.state = :retreat if @health <= 30
    end

    if @despawn
      self.alpha-=2
      self.destroy if self.alpha <= 0
    end

    check_health
  end

  def fire_bullet!
    dx = @target.x - self.x
    dy = @target.y - self.y
    length = Math.sqrt( dx*dx + dy*dy )
    dx /= length; dy /= length
    dx *= @speed; dy *= @speed

    velocity_x = dx*3#/100
    velocity_y = dy*3#/100

    # distance   = Gosu.distance(self.x, self.y, @target.x, @target.y)
    Bullet.create(x: self.x, y: self.y, z: 199, velocity_x: velocity_x, velocity_y: velocity_y) if @target_area.in_range && self.alpha >= 255
  end

  def check_health
    if @health <= 0
      Empty.create(x: self.x, y: self.y)
      Gosu::Sample["#{AssetManager.sounds_path}/explosion.ogg"].play if ConfigManager.config["sounds"]
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
    @portal.despawn(false) if defined?(@portal)
    # TODO: Respawn enemies that despawn during Wave gamemode
    # GameInfo::Mode.wave_enemies_spawned-=1 if defined?(@portal) && @health >= 1
    @target_area.destroy
  end

  def self.spawn(portal)
    Enemy.create(x: portal.x, y: portal.y)
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
end
