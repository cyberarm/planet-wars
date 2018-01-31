class Ship < GameObject
  attr_accessor :boost, :max_boost, :health, :max_health, :dead, :speed, :boost_speed, :diamond, :gold, :oil
  attr_reader   :active_speed, :lock_speed, :lock_max_boost, :lock_boost_speed, :ship_size, :border

  def setup
    @moving      = false
    @dead        = false
    @warning     = false
    @health      = 100
    @max_health  = 100
    @speed       = 3
    @old_speed   = 3
    @active_speed= 0
    @speed_rate  = 0.05
    @boost       = 0
    @boost_speed = 1
    @max_boost   = 100
    @rotaion_speed=2.5
    @particle_img = AssetManager.get_image("#{AssetManager.particles_path}/exhaust.png")
    @particle_img_boost = AssetManager.get_image("#{AssetManager.particles_path}/boost_exhaust.png")

    # self.input = {
    #   [:space, :gp_0] => :fire_weapon,
    #   [:holding_left_shift, :holding_right_shift, :holding_gp_1] => :boost_key,
    #   [:holding_w,:holding_up, :holding_gp_10]       => :move_up,
    #   [:holding_s,:holding_down, :holding_gp_9]   => :move_down,
    #   [:holding_a,:holding_left, :holding_gp_left]   => :move_left,
    #   [:holding_d,:holding_right, :holding_gp_right] => :move_right}
    self.z  = 301

    @diamond = 0
    @gold    = 400
    @oil     = 0

    @ship_check = 0

    @border= @options[:world]
    @image = AssetManager.get_image("#{AssetManager.ships_path}/ship.png")
    @particle = ParticleEmitter.new(x: self.x, y: self.y, z: 1, max_particles: 500)
    self.scale(1.1)
    @ship_size = 64/2

    @lock_max_boost = 400
    @lock_boost_speed = 3
    @lock_speed = 5

    @warning_time = Time.now
  end

  def update
    if @boosting
      @particle.particle_image = AssetManager.get_image(AssetManager.particles_path+"/boost_exhaust.png")
    else
      @particle.particle_image = AssetManager.get_image(AssetManager.particles_path+"/exhaust.png")
    end

    if Time.now.to_f-@warning_time.to_f >- 0.5
      @warning = false
      @warning_time = Time.now
    end

    if @active_speed <= 1.0
      @particle.emit = false
    else
      @particle.emit = true
    end

    @particle.x = self.x
    @particle.y = self.y

    ship_check
    health_check
    mover
    set_active_speed
    @speed = @old_speed
    @moving = false
    @boosting = false
  end

  def button_up(id)
    if Gosu::KbSpace || Gosu::Gp0
      boost_key
    end
  end

  def button_down?(id)
    if Gosu::KbLeftShift || Gosu::KbRightShift || Gosu::Gp1
      boost_key
    elsif Gosu::KbW || Gosu::KbUp || Gosu::Gp10
      move_up
    elsif Gosu::KbS || Gosu::KbDown || Gosu::Gp9
      move_down
    elsif Gosu::KbA || Gosu::KbLeft || Gosu::GpLeft
      move_left
    elsif Gosu::KbD || Gosu::KbRight || Gosu::GpRight
      move_right
    end
  end

  def hit(damage, object)
    @object = object
    @health-=damage
  end

  def health_check
    if @health <= 30
      GameHUD.message("Low Health", Gosu::Color::RED)
    end

    if @health <= 0
      die
    end
    @warning = true
  end

  def die
    self.scale = 0.0
    @dead = true
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

  def mover
    speed = (@speed*60)*Engine.dt
    active_speed = (@active_speed*60)*Engine.dt
    _x = active_speed * Math.cos((90.0 + angle) * Math::PI / 180)
    _y = active_speed * Math.sin((90.0 + angle) * Math::PI / 180)
    self.x -= _x
    self.y -= _y

    if self.y >= @border[3]-@ship_size
      self.y-=speed
    end
    if self.x >= @border[1]-@ship_size
      self.x-=speed
    end
    if self.y <= @border[2]+@ship_size
      self.y+=speed
    end
    if self.x <= @border[0]+@ship_size
      self.x+=speed
    end
  end

  def set_active_speed
    unless @moving
      @active_speed-=@speed_rate/6.0 unless @active_speed <= @speed_rate
      @active_speed+=@speed_rate unless @active_speed >= -@speed_rate
    end
  end

  # Key checks
  def upgrade_speed
    if Base.all.count > 0 && self.gold >= 200
      unless @old_speed >= @lock_speed
        @old_speed+=1
        self.gold-=200
      end
    end
  end
  def upgrade_boost_speed
    if Base.all.count > 0 && self.gold >= 100
      unless @boost_speed >= @lock_boost_speed
        @boost_speed+=1
        self.gold-=100
      end
    end
  end
  def upgrade_boost_capacity
    if Base.all.count > 0 && self.gold >= 100
      unless @max_boost >= @lock_max_boost
        @max_boost+=50
        self.gold-=100
      end
    end
  end

  def fire_weapon
    Bullet.new(x: self.x, y: self.y, z: 199, host_angle: self.angle, created_by: self)
    GameInfo::Config.bullet_shot
  end

  def boost_key
    @boosting = true && @speed+=@boost_speed unless @speed+@boost_speed > @old_speed+@boost_speed if self.boost >= 2
    @speed = @old_speed if self.boost <= 0
    self.boost -= 1 unless self.boost <= 0
  end

  def move_up
    @moving = true
    @active_speed+=@speed_rate
    @active_speed=@speed if @active_speed >= @speed
  end

  def move_down
    @moving = true
    @active_speed-=@speed_rate
    @active_speed=-@speed if @active_speed <= -@speed
  end

  def move_left
    rotaion_speed = (@rotaion_speed*60)*Engine.dt
    self.angle-=(rotaion_speed)
  end

  def move_right
    rotaion_speed = (@rotaion_speed*60)*Engine.dt
    self.angle+=(rotaion_speed)
  end
end
