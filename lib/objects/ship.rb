class Ship < Chingu::GameObject
  trait :effect
  trait :velocity
  trait :bounding_circle
  trait :collision_detection

  attr_accessor :boost, :max_boost, :health, :speed, :boost_speed, :diamond, :gold, :oil

  def setup
    @health      = 100
    @speed       = 3
    @max_speed   = 20
    @boost       = 0
    @boost_speed = 2
    @max_boost   = 100
    @particle_img = TexPlay.create_image($window, 10, 10, color: :yellow)
    self.max_velocity = @max_speed

    @diamond = 0
    @gold    = 0
    @oil     = 0

    @ship_check = 0

    @border= @options[:world]
    @image = Gosu::Image["ships/ship.png"]
    @particle=Ashton::ParticleEmitter.new(self.x, self.y, 10, image: @particle_img, scale: 1.0,speed: 20,friction: 0.1,max_particles: 1000,interval: 0.003,fade: 100,angular_velocity: -200..200)
    self.scale_out(0.1)
    @ship_size = 64/2
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

    key_check
    ship_check
  end

  # check movement
  def key_check
    if $window.button_down?(Gosu::KbUp) or $window.button_down?(Gosu::KbW)
      if self.y >= @border[2]+@ship_size
        if $window.button_down?(Gosu::KbLeftShift)
          self.move(0, -(@speed+@boost_speed)) if self.boost >= 1
          self.move(0, -@speed) unless self.boost >= 1
        else
          self.move(0, -@speed)
        end
      end
      self.angle = (0)
    end

    if $window.button_down?(Gosu::KbDown) or $window.button_down?(Gosu::KbS)
      if self.y <= @border[3]-@ship_size
        if $window.button_down?(Gosu::KbLeftShift)
          self.move(0, @speed+@boost_speed) if self.boost >= 1
          self.move(0, @speed) unless self.boost >= 1
        else
          self.move(0, @speed)
        end
      end
      self.angle = (180)
    end

    if $window.button_down?(Gosu::KbRight) or $window.button_down?(Gosu::KbD)
      if self.x <= @border[1]-@ship_size
        if $window.button_down?(Gosu::KbLeftShift)
          self.move(@speed+@boost_speed, 0) if self.boost >= 1
          self.move(@speed, 0) unless self.boost >= 1
        else
          self.move(@speed, 0)
        end
      end
      self.angle = (90)
    end

    if $window.button_down?(Gosu::KbLeft) or $window.button_down?(Gosu::KbA)
      if self.x >= @border[0]+@ship_size
        if $window.button_down?(Gosu::KbLeftShift)
          self.x-=@speed+@boost_speed if self.boost >= 1
          self.x-=@speed unless self.boost >= 1
        else
          self.x-=@speed
        end
      end
      self.angle = (270)
    end

    if $window.button_down?(Gosu::KbLeftShift)
      self.boost -= 1 unless self.boost <= 0
    end
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
end