class Enemy < Chingu::GameObject
  attr_reader :health
  attr_accessor :move, :health
  trait :effect
  trait :timer
  trait :bounding_circle
  trait :collision_detection
  def setup
    self.zorder = 200
    self.alpha = 0
    @speed = 2
    @health= 40
    @image = Gosu::Image["#{AssetManager.ships_path}/enemy.png"]
    @target = TargetArea.create(owner: self, target: Ship.all.first)
    @dx = 0
    @dy = 0
    every(1000) do
      Bullet.create(x: self.x, y: self.y, z: 199, created_by_enemy: true, velocity_x: @dx*3, velocity_y: @dy*3) if @target.in_range && self.alpha >= 255
    end
  end

  def draw
    super
  end

  def update
    self.alpha+=2
    rotate(rand(0.0..1.0))
    if defined?(@ship) && self.alpha >= 255
      @dx = @ship.x - self.x
      @dy = @ship.y - self.y
      length = Math.sqrt( @dx*@dx + @dy*@dy )
      @dx /= length; @dy /= length
      @dx *= @speed; @dy *= @speed
      self.x += @dx
      self.y += @dy
    else
      @ship  = Ship.all.first
    end

    check_health
  end

  def check_health
    if @health <= 0
      Empty.create(x: self.x, y: self.y)
      Gosu::Sample["#{AssetManager.sounds_path}/explosion.ogg"].play
      self.destroy
    end
  end

  def hit(damage)
    @health-=damage if self.alpha >= 255
  end

  def self.spawn(portal)
    Enemy.create(x: portal.x, y: portal.y)
  end
end