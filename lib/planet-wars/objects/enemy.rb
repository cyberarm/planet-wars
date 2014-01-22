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
    @target = Target.create(x: 0, y: 0)
    @target_area = TargetArea.create(owner: self, target: @target, size: 235.0)
    @tick = 0
    @dx = 0
    @dy = 0

    every(1000) do
      Bullet.create(x: self.x, y: self.y, z: 199, created_by_enemy: true, velocity_x: @dx*3, velocity_y: @dy*3) if @target_area.in_range && self.alpha >= 255
      # GameInfo::Config.bullet_shot if @target.in_range && self.alpha >= 255
    end
  end

  def draw
    super
  end

  def update
    self.alpha+=2
    @tick+=1
    rotate(rand(0.0..1.0))
    if defined?(@target_area) && @target_area.in_range && self.alpha >= 255
      @dx = @target.x - self.x
      @dy = @target.y - self.y
      length = Math.sqrt( @dx*@dx + @dy*@dy )
      @dx /= length; @dy /= length
      @dx *= @speed; @dy *= @speed
      self.x += @dx
      self.y += @dy
    end

    if @tick >= 10
      @tick = 0
      @target.x,@target.y = Ship.all.first.x,Ship.all.first.y
    end
    check_health
  end

  def check_health
    if @health <= 0
      Empty.create(x: self.x, y: self.y)
      Gosu::Sample["#{AssetManager.sounds_path}/explosion.ogg"].play
      GameInfo::Config.killed
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