class Bullet < Chingu::GameObject
  trait :velocity
  trait :bounding_circle
  trait :collision_detection

  def setup
    self.zorder = 200
    @image = Gosu::Image[AssetManager.bullets_path+'/bullet.png']
    Gosu::Sample["#{AssetManager.sounds_path}/laser.ogg"].play if ConfigManager.config["sounds"]
    @ship  = @options[:ship]
    @speed = 10
    @damage=10.0
    @dead  = false
    set_velocity
  end

  def update
    self.alpha-=2
    self.die if alpha <= 0
    @damage-=0.04
    check_collisions
  end

  def set_velocity
    if @ship
      direction = (@ship.angle - 90.0) * (Math::PI / 180.0)
      self.velocity_x = @speed*Math.cos(direction)
      self.velocity_y = @speed*Math.sin(direction)
    end
  end

  def die
    self.destroy
  end

  def check_collisions
    unless @ship
      self.each_collision(Ship) do |bullet, ship|
        self.die
        Gosu::Sample["#{AssetManager.sounds_path}/hit.ogg"].play(0.1) if ConfigManager.config["sounds"]
        ship.hit(@damage, self)
      end
    else
      self.each_collision(Enemy) do |bullet, enemy|
        self.die
        Gosu::Sample["#{AssetManager.sounds_path}/hit.ogg"].play(0.1) if ConfigManager.config["sounds"]
        enemy.hit(@damage, self)
      end
    end

      self.each_collision(Asteroid) do |bullet, asteroid|
        self.die
        Gosu::Sample["#{AssetManager.sounds_path}/hit.ogg"].play(0.1) if ConfigManager.config["sounds"]
        asteroid.hit(@damage, self)
      end
  end
end