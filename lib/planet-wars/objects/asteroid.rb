class Asteroid < Chingu::GameObject
  trait :effect
  trait :velocity
  trait :bounding_circle
  trait :collision_detection

  def setup
    @image = Gosu::Image["#{AssetManager.asteroids_path}/asteroid-01.png"]
    @speed = 5
    @damage= 50
    @rotation = rand(-5..5)
    self.zorder = 199
    self.factor = rand(0.1..1.0)
    placer
    set_velocity
  end

  def update
    rotate(@rotation)
    check_for_collisions
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
    unless self.x.between?(0, 3000) && self.y.between?(0, 3000)
      self.destroy
    end
  end

  def set_velocity
      @dx = rand(-1500..1500) - self.x
      @dy = rand(-1500..1500) - self.y
      length = Math.sqrt( @dx*@dx + @dy*@dy )
      @dx /= length; @dy /= length
      @dx *= @speed; @dy *= @speed
      self.velocity_x += @dx
      self.velocity_y += @dy
  end
end