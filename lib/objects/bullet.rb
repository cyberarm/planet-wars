class Bullet < Chingu::GameObject
  trait :timer
  trait :velocity
  trait :bounding_circle
  trait :collision_detection

  def setup
    @image = Gosu::Image["#{AssetManager.bullets_path}/bullet.png"]
    @ship  = @options[:ship]
    @created_by_enemy = @options[:created_by_enemy]
    @particle=Ashton::ParticleEmitter.new(self.x, self.y, 199, image: @image, scale: 0.3,speed: 20,friction: 0.1,max_particles: 50,interval: 0.01,fade: 100,angular_velocity: -200..200)
    @dead  = false
    set_velocity

    after(2000) {die}
  end

  def draw
    super
    @particle.draw if @dead
  end

  def update
    @last_update_at ||= Gosu::milliseconds
    @particle.update ([Gosu::milliseconds - @last_update_at, 100].min * 0.001)
    @last_update_at = Gosu::milliseconds
    @particle.x = self.x
    @particle.y = self.y

    check_collisions unless @dead
  end

  def set_velocity
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

  def die
    self.scale = 0.1
    @dead = true
    self.velocity_x = 0
    self.velocity_y = 0
    after(1000) {self.destroy}
  end

  def check_collisions
    if created_by_enemy?
      self.each_collision(Ship) do |bullet, ship|
        puts "Bug"
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