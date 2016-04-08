class Asteroid < Chingu::GameObject
  trait :effect
  trait :velocity
  trait :bounding_circle
  trait :collision_detection

  attr_accessor :health

  def setup
    asteroid_images = Dir["#{AssetManager.asteroids_path}/*.png"]
    random = rand(asteroid_images.count)
    @image = Gosu::Image["#{AssetManager.asteroids_path}/#{File.basename(asteroid_images[random])}"]
    trait_options[:bounding_circle][:scale] = 0.8
    @health= 200
    @speed = 5*60
    @damage= 50
    @rotation = rand(-5..5)
    self.zorder = 300
    self.factor = rand(0.1..1.0)
    placer
    set_velocity
  end

  def update
    rotation = (@rotation*60)*Engine.dt
    rotate(rotation)
    check_for_collisions
    update_velocity
    destroy_self?
  end

  def placer
    case rand(4)
    when 1
      self.x = 0
      self.y = 0
    when 2
      self.x = 3000
      self.y = 3000
    when 3
      self.x = 3000
      self.y = 0
    when 4
      self.x = 0
      self.y = 3000
    end
  end

  def check_for_collisions
    self.each_collision(Ship) do |a,t|
      t.hit(@damage, self)
    end

    self.each_collision(Enemy) do |a,t|
      t.hit(@damage, self)
    end
  end

  def destroy_self?
    self.destroy if self.health <= 0
    unless self.x.between?(-512, 3512) && self.y.between?(-512, 3512)
      self.destroy
    end
  end

  def set_velocity
    @dx = rand(-1500..1500) - self.x
    @dy = rand(-1500..1500) - self.y
    length = Math.sqrt( @dx*@dx + @dy*@dy )
    @dx /= length; @dy /= length
  end

  def update_velocity
    dx, dy = @dx, @dy
    speed = @speed*Engine.dt
    dx *= speed; dy *= speed
    self.velocity_x = dx
    self.velocity_y = dy
  end

  def hit(damage, bullet)
    self.health-=damage
  end
end
