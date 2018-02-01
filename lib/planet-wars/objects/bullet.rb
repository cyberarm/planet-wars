class Bullet < GameObject
  def self.speed
    10*45
  end

  def setup
    @debug_color = Gosu::Color.rgb(200,0,150)

    self.z = Float::INFINITY
    @image = AssetManager.get_image(AssetManager.bullets_path+'/bullet.png')
    AssetManager.get_sample("#{AssetManager.sounds_path}/laser.ogg").play if ConfigManager.play_sounds?
    @ship  = @options[:ship]
    @speed = Bullet.speed
    @damage= 10.0
    @dead  = false
    @host_angle = @options[:host_angle]
    @created_by = @options[:created_by]

    set_velocity
  end

  def update
    alpha = 120*Engine.dt
    damage = (0.04*60)*Engine.dt
    self.alpha-=alpha
    self.die if self.alpha <= 0
    @damage-=damage
    check_collisions
    update_velocity
  end

  def update_velocity
    speed = @speed*Engine.dt

    self.x += speed*Math.cos(@direction)
    self.y += speed*Math.sin(@direction)
  end

  def set_velocity
    speed = @speed*Engine.dt

    @direction = (@host_angle - 90.0) * (Math::PI / 180.0)
  end

  def die
    self.destroy
  end

  def check_collisions
    if @created_by.is_a?(Enemy)
      self.each_circle_collision(Ship) do |bullet, ship|
        if true # TODO: Check pixel collision
          self.die
          AssetManager.get_sample("#{AssetManager.sounds_path}/hit.ogg").play(0.1) if ConfigManager.play_sounds?
          ship.hit(@damage, self)
        end
      end
    else
      self.each_circle_collision(Enemy) do |bullet, enemy|
        self.die
        AssetManager.get_sample("#{AssetManager.sounds_path}/hit.ogg").play(0.1) if ConfigManager.play_sounds?
        enemy.hit(@damage, self)
      end
    end

    self.each_circle_collision(Asteroid) do |bullet, asteroid|
      self.die
      AssetManager.get_sample("#{AssetManager.sounds_path}/hit.ogg").play(0.1) if ConfigManager.play_sounds?
      asteroid.hit(@damage, self)
    end
  end
end
