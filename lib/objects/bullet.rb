class Bullet < Chingu::GameObject
  trait :timer
  trait :velocity
  trait :bounding_circle
  trait :collision_detection

  def setup
    self.zorder = 200
    @image = Gosu::Image[AssetManager.bullets_path+'/bullet.png']
    @ship  = @options[:ship]
    @created_by_enemy = @options[:created_by_enemy]
    @dead  = false
    set_velocity

    after(2000) {die}
  end

  def update
    check_collisions unless @dead
  end

  def set_velocity
    unless @created_by_enemy
      case @ship.angle
      when 0
        self.velocity_y=-10
      when 180
        self.velocity_y=10
      when 270
        self.velocity_x=-10
      when 90
        self.velocity_x=10
      end
    end
  end

  def die
    @dead = true
    self.velocity_x = 0
    self.velocity_y = 0
    self.destroy
  end

  def check_collisions
    if created_by_enemy?
      self.each_collision(Ship) do |bullet, ship|
        self.die
        ship.hit
      end
    else
      self.each_collision(Enemy) do |bullet, enemy|
        self.die
        enemy.hit
      end
    end
  end

  def created_by_enemy?
    @created_by_enemy
  end
end