class Bullet < Chingu::GameObject
  trait :velocity
  trait :bounding_circle
  trait :collision_detection

  def self.speed
    10*40
  end

  def setup
    self.zorder = Float::INFINITY
    @image = Gosu::Image[AssetManager.bullets_path+'/bullet.png']
    Gosu::Sample["#{AssetManager.sounds_path}/laser.ogg"].play if ConfigManager.play_sounds?
    @ship  = @options[:ship]
    @speed = Bullet.speed
    @damage=10.0
    @dead  = false
    @host_angle = @options[:host_angle]
    @created_by = @options[:created_by]

    set_velocity
  end

  def update
    alpha = 120*Engine.dt
    damage = (0.04*60)*Engine.dt
    self.alpha-=alpha
    self.die if alpha <= 0
    @damage-=damage
    check_collisions
    update_velocity
  end

  def update_velocity
    speed = @speed*Engine.dt

    self.velocity_x = speed*Math.cos(@direction)
    self.velocity_y = speed*Math.sin(@direction)
  end

  def set_velocity
    speed = @speed*Engine.dt

    @direction = (@host_angle - 90.0) * (Math::PI / 180.0)
    self.velocity_x = speed*Math.cos(@direction)
    self.velocity_y = speed*Math.sin(@direction)
  end

  def die
    self.destroy
  end

  def check_collisions
    if @created_by.is_a?(Enemy)
      self.each_collision(Ship) do |bullet, ship|
        if true # TODO: Check pixel collision
          self.die
          Gosu::Sample["#{AssetManager.sounds_path}/hit.ogg"].play(0.1) if ConfigManager.play_sounds?
          ship.hit(@damage, self)
        end
      end

    else
      self.each_collision(Enemy) do |bullet, enemy|
        self.die
        Gosu::Sample["#{AssetManager.sounds_path}/hit.ogg"].play(0.1) if ConfigManager.play_sounds?
        enemy.hit(@damage, self)
      end
    end

    self.each_collision(Asteroid) do |bullet, asteroid|
      self.die
      Gosu::Sample["#{AssetManager.sounds_path}/hit.ogg"].play(0.1) if ConfigManager.play_sounds?
      asteroid.hit(@damage, self)
    end
  end
end
