class Bullet < Chingu::GameObject
  trait :velocity
  trait :bounding_circle
  trait :collision_detection

  def setup
    self.zorder = 200
    @image = Gosu::Image[AssetManager.bullets_path+'/bullet.png']
    Gosu::Sample["#{AssetManager.sounds_path}/laser.ogg"].play
    @ship  = @options[:ship]
    @speed = 10
    @damage=10.0
    @dead  = false
    @alive_tick = 0
    set_velocity
  end

  def update
    @alive_tick+=1
    self.alpha-=2
    self.die if alpha <= 0
    @damage-=0.04
    check_collisions
  end

  def set_velocity
    if @ship
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
    self.destroy
  end

  def check_collisions
    if @alive_tick >= 20
      self.each_collision(Ship) do |bullet, ship|
        self.die
        Gosu::Sample["#{AssetManager.sounds_path}/hit.ogg"].play(0.1)
        ship.hit(@damage)
      end
      
      self.each_collision(Enemy) do |bullet, enemy|
        self.die
        Gosu::Sample["#{AssetManager.sounds_path}/hit.ogg"].play(0.1)
        enemy.hit(@damage)
      end
    end
  end
end