class Ship < Chingu::GameObject
  trait :effect
  trait :bounding_circle
  trait :collision_detection
  # trait :viewport

  attr_accessor :boost, :max_boost, :health, :speed, :boost_speed, :diamond, :gold, :oil

  def setup
    @health      = 100
    @speed       = 3
    @boost_speed = 2
    @boost       = 0
    @max_boost   = 100

    @diamond = 0
    @gold    = 0
    @oil     = 0

    @ship_check = 0

    @border= @options[:world]
    @image = Gosu::Image["ships/ship.png"]
    # @particle=Chingu::Particle.new
    self.scale_out(0.1)
    @ship_size = 64/2

    # viewport.lag  = 0.22
    # viewport.game_area = [0, 0, 1000*3, 1000*3]
  end

  def update
    # self.viewport.center_around(self)
    # rotation = Math.atan2(self.y - $window.mouse_y, self.x - $window.mouse_x)
    # 
    # self.x -= 1 * Math.cos(rotation)
    # self.y -= 1 * Math.sin(rotation)
    key_check
    ship_check
    # collision_check
  end

  def key_check
    # check movement
    if $window.button_down?(Gosu::KbUp) or $window.button_down?(Gosu::KbW)
      if self.y >= @border[2]+@ship_size
        if $window.button_down?(Gosu::KbLeftShift)
          self.y-=@speed+@boost_speed if self.boost >= 1
          self.y-=@speed unless self.boost >= 1
        else
          self.y-=@speed
        end
      end
      self.angle = (0)
    end

    if $window.button_down?(Gosu::KbDown) or $window.button_down?(Gosu::KbS)
      if self.y <= @border[3]-@ship_size
        if $window.button_down?(Gosu::KbLeftShift)
          self.y+=@speed+@boost_speed if self.boost >= 1
          self.y+=@speed unless self.boost >= 1
        else
          self.y+=@speed
        end
      end
      self.angle = (180)
    end

    if $window.button_down?(Gosu::KbRight) or $window.button_down?(Gosu::KbD)
      if self.x <= @border[1]-@ship_size
        if $window.button_down?(Gosu::KbLeftShift)
          self.x+=@speed+@boost_speed if self.boost >= 1
          self.x+=@speed unless self.boost >= 1
        else
          self.x+=@speed
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