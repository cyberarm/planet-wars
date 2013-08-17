class Ship < Chingu::GameObject
  trait :effect
  trait :velocity
  trait :bounding_circle
  trait :collision_detection

  attr_accessor :boost, :max_boost, :health, :speed, :boost_speed, :diamond, :gold, :oil

  def setup
    @health      = 100
    @speed       = 3
    @old_speed   = 3
    @boost       = 0
    @boost_speed = 1
    @max_boost   = 100
    @particle_img = TexPlay.create_image($window, 10, 10, color: :yellow)

    self.input = {
      [:space, :gp_0, :gp_5] => :fire_weapon,
      [:holding_left_shift, :holding_right_shift, :holding_gp_4] => :boost_key,
      [:holding_w,:holding_up, :holding_gp_up]       => :move_up,
      [:holding_s,:holding_down, :holding_gp_down]   => :move_down,
      [:holding_a,:holding_left, :holding_gp_left]   => :move_left,
      [:holding_d,:holding_right, :holding_gp_right] => :move_right}
    self.zorder  = 300
    self.velocity_x     = 0
    self.velocity_y     = 0
    self.max_velocity   = @speed

    @diamond = 0
    @gold    = 0
    @oil     = 0

    @ship_check = 0

    @border= @options[:world]
    @image = Gosu::Image["#{AssetManager.ships_path}/ship.png"]
    @particle=Ashton::ParticleEmitter.new(self.x, self.y, 299, image: @particle_img, scale: 1.0,speed: 20,friction: 0.1,max_particles: 400,interval: 0.006,fade: 100,angular_velocity: -200..200)
    self.scale_out(0.1)
    @ship_size = 64/2

    @lock_max_boost = 400
    @lock_boost_speed = 3
    @lock_speed = 5
  end

  def draw
    super
    @particle.draw
  end

  def update
    @last_update_at ||= Gosu::milliseconds
    @particle.update ([Gosu::milliseconds - @last_update_at, 100].min * 0.001)
    @last_update_at = Gosu::milliseconds
    @particle.x = self.x
    @particle.y = self.y
    ship_check
    upgrade_check # Chingu WHY U NO WORK WITH NUMBERS!?!??!?!?!?!
    @speed = @old_speed
  end

  def hit
    @health-=10
  end

  def upgrade_check
    upgrade_speed if $window.button_down?(Gosu::Kb1)
    upgrade_boost_speed if $window.button_down?(Gosu::Kb2)
    upgrade_boost_capacity if $window.button_down?(Gosu::Kb3)
  end

  def ship_check
    if @ship_check == 3
      if self.boost < self.max_boost
        self.boost  += 1
      end
      @ship_check  = 0
    end

    @ship_check += 1
  end

  # Key checks
  def upgrade_speed
    @old_speed+=1 unless @old_speed >= @lock_speed
  end
  def upgrade_boost_speed
    @boost_speed+=1 unless @boost_speed >= @lock_boost_speed
  end
  def upgrade_boost_capacity
    @max_boost+=1 unless @max_boost >= @lock_max_boost
  end

  def fire_weapon
    Bullet.create(x: self.x, y: self.y, z: 199, ship: self, created_by_enemy: false)
  end

  def boost_key
    @speed+=@boost_speed unless @speed+@boost_speed > @old_speed+@boost_speed if self.boost >= 1
    @speed = @old_speed if self.boost <= 0
    self.boost -= 1 unless self.boost <= 0
  end

  def move_up
    if self.y >= @border[2]+@ship_size
      self.move(0, -@speed)
    end
    self.angle = (0)
  end

  def move_down
    if self.y <= @border[3]-@ship_size
      self.move(0, @speed)
    end
    self.angle = (180)
  end

  def move_left
    if self.x >= @border[0]+@ship_size
      self.x-=@speed
    end
    self.angle = (270)
  end

  def move_right
    if self.x <= @border[1]-@ship_size
      self.move(@speed, 0)
    end
    self.angle = (90)
  end
end